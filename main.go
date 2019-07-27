package main

import (
	"bufio"
	"flag"
	"fmt"
	"os"
	"strings"
	"time"
)

func main() {
	var cmd string
	flag.StringVar(&cmd, "cmd", "new", "cmd for cli")

	var postType string
	flag.StringVar(&postType, "type", "regular", "type of blog post (micro/long/regular)")

	var postTitle string
	flag.StringVar(&postTitle, "title", "", "title of blog post - must be dash delimited")

	var postPublished string
	flag.StringVar(&postPublished, "publish", "false", "if post should be available to be seen (true/false)")

	flag.Parse()

	switch cmd {
	case "new":
		newPost(postType, postTitle, postPublished)
		break
	default:
		flag.PrintDefaults()
		break
	}
}

func newPost(postType string, postTitle string, postPublished string) {
	if postTitle == "" || !strings.Contains(postTitle, "-") {
		flag.PrintDefaults()
		os.Exit(1)
	}

	postTime := strings.Split(time.Now().String(), " ")[0]
	postHeader := []string{"---", "layout: post"}
	cleanTitle := strings.Title(strings.ReplaceAll(postTitle, "-", " "))

	if strings.ToLower(postType) == "micro" {
		headerTitle := fmt.Sprintf("title: Micro: %s", cleanTitle)

		postHeader = append(postHeader, headerTitle)
	} else if strings.ToLower(postType) == "long" {
		headerTitle := fmt.Sprintf("title: Long: %s", cleanTitle)

		postHeader = append(postHeader, headerTitle)
	} else {
		headerTitle := fmt.Sprintf("title: %s", cleanTitle)

		postHeader = append(postHeader, headerTitle)
	}

	postHeader = append(postHeader, "published: "+postPublished)
	postHeader = append(postHeader, "---")
	postHeader = append(postHeader, "\n# "+postTitle+"\n"+"\n_Content_")

	writeLines(postHeader, "_posts/"+postTime+"-"+postTitle+".md")
}

func writeLines(lines []string, path string) {
	file, err := os.Create(path)
	if err != nil {
		panic(err)
	}

	defer file.Close()

	w := bufio.NewWriter(file)
	for _, line := range lines {
		w.WriteString(line + "\n")
	}

	w.Flush()
}
