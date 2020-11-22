---
layout: post
title: "Integrating Hyperapp Into Legacy MVCs"
date: 2017-12-30 14:43:44 -0600
categories: domevents
---

# Integrating Hyperapp Into Legacy MVCs

So you have discovered the wonderful world of Hyperapp and you want to use it
at work or on an older project to revamp the frontend a little bit. What are the
first steps?

### MVCs

If your app is built with something like Rails/Django/Phoenix/Laravel it would
make sense to keep the routing on backend since it does that job really well.

_But how will I make an SPA?_

You won't make **one** but **many**! The idea will be that you app already has
places your users go to, patterns they are used to, and workflows that are in
place. So each route will be it's own SPA, or have a few hyperapps.

Example structure (using Rails as an example):

_even though I am going to use Rails as an example, the same concepts apply for
using `EJS` with Node/Express, etc.._

```html
# Header/Navbar partial

<div id="navbar_root">
  <%= javascript_pack_tag 'navbar' %> # Profile page partial

  <div id="profile_page_root">
    <%= javascript_pack_tag 'profilePage' %> # Footer partial

    <div id="footer_root">
      <%= javascript_pack_tag 'footer' %>
    </div>
  </div>
</div>
```

Each partial (_traditional server side template component_) will have its own
Hyperapp that calls in a seperate bundle. Each bundle can use shared components
(views) but the bundles themselves will be unique, as each partial is unique.

`javascript_pack_tag` here simply refers a chunkHash that `webpacker` (the Rails
solution to using webpack) makes when writing a bundle.

Structure looks like so:

```javascript
javascript / appActions / appState / models / appComponents / SomeView.js;
AnotherView.js;
utils / sharedInternalUtils.js;
packs / profilePage.js;
navbar.js;
footer.js;
stuff.js;
thing.js;
otherThing.js;
otherStuff.js;
```

Components can be shared while having individual packs!

Now, we need to talk about the bootstrapping process. This will be important.

When your JS hits the page your backend is the source of truth, and since some
of the HTML is still being rendered server side, you can take advantage of the
backend and have it feed your frontend information like:

```ruby
@current_user
@endpoint
@can_edit_page
@can_upload_picture_larger_than_2mb
```

Now you can create HTML safe JSON for your frontend to grab:

```javascript
<script id="profile_page_data">
  <%= {
    current_user: @current_user,
    endpoint: @endpoint,
    can_edit_page: @can_edit_page,
    can_upload_picture_larger_than_2mb: @can_upload_picture_larger_than_2mb,
  }.to_json.html_safe %>
</script>
```

This way you can create even more dynamic view functions for your app! Now that
you never have to hardcode an API endpoint again, your views will continue to
work without exploding because some API call has changed when the backend team
has refactored routes or something of that nature.

You pull in some data from the DOM, then make an API call for custom user data.

Now you need to grab the data (in your pack tag prior to calling your comp/view)

```javascript
// profilePage.js

import { app } from "hyperapp";
import { state, actions } from "./../models/ProfilePageModel";
import ProfilePageComp from "./../components/ProfilePageComp";

const { innerHTML } = document.getElementById("profile_page_data");
const data = JSON.parse(dataNode.innerHTML);

// now that you have some backend data, merge it with your app state
const appState = Object.assign({}, state, data);

const { someAction, anotherAction, makeApiCall } = app(
  state,
  actions,
  ProfilePageComp,
  document.getElementById("profile_page_root")
);

// make the intial api call to populate the DOM with user specific profile data
makeApiCall();
```

### jQuery...

Now let's say that the profilePage entry point is in the middle of some DOM that
is bound by jQuery. That jQuery can still talk to the Hyperapp app via exposed
actions!

```javascript
const {
  someActionThatSavesTheProfile,
} = app(
  ...
)

/*
  Say for some reason that your ProfilePageComp maintains all internal state
  but because designers are hard at work redesigning the section just below all
  the cogs and wigdgets built in Hyperapp, that the save button is still part of
  the jQuery part of the page, now you can just change the function it calls!
*/
$('#saveProfile').on('click', someActionThatSavesTheProfile);
```

Hyperapps can talk to eachother this way too. [Here is an example I wrote on
Codepen](https://codepen.io/selfup/pen/jLMRjO) of plain old JS talking to HA.
Which means that if someone adds an item to their cart, the ItemsApp can still
make a call to an exposed NavBar actions that will update the cart number for example.

Hyperapps can talk to jQuery the old fashioned way, but I would try my best to
never mix jQuery inside the VDOM!

### Conclusion

The big advantage here is that because we can sprinkle in little apps one by one, eventually all of the components can get merged once a certain route is finished being completely converted, and then you can start utilizing a frontend router and just keep the backend as an Auth mecahnism and an API.
