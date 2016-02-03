package main

import (
	"fmt"
	"io"
	"net/http"
	"net/url"
	"os"
	"strconv"
	"strings"

	"github.com/135yshr/goracom"
)

func main() {
	fmt.Println("start slack")

	// goproxy is executed as a short lived process to send a request to the
	// goproxy daemon process
	if len(os.Args) > 1 {
		// If there's an argument
		// It will be considered as a path for an HTTP GET request
		// That's a way to communicate with goproxy daemon
		if len(os.Args) == 2 {
			reqPath := "http://127.0.0.1:8000/" + os.Args[1]
			resp, err := http.Get(reqPath)
			if err != nil {
				fmt.Println("Error on request:", reqPath, "ERROR:", err.Error())
			} else {
				fmt.Println("Request sent", reqPath, "StatusCode:", resp.StatusCode)
			}
		}
		return
	}

	// start a http server and listen on local port 8000
	go func() {
		http.HandleFunc("/containers", listContainers)
		// http.HandleFunc("/exec", execCmd)
		http.ListenAndServe(":8000", nil)
	}()

	// wait for interruption
	<-make(chan int)
}

// listContainers handles and reply to http requests having the path "/containers"
func listContainers(w http.ResponseWriter, r *http.Request) {

	// answer right away to avoid dead locks in LUA
	io.WriteString(w, "OK")

	email := os.Getenv("SORACOM_EMAIL")
	pass := os.Getenv("SORACOM_PASSWORD")
	c, _ := goracom.NewClient(email, pass)
	s := c.NewSubscriber()
	ss, _ := s.Sim("440103088701722")

	go func() {
		data := url.Values{
			"action":    {"containerInfos"},
			"id":        {ss.IMSI},
			"name":      {ss.Tags["name"]},
			"imageRepo": {ss.APN},
			"imageTag":  {ss.ModuleType},
			"running":   {strconv.FormatBool(ss.Status == "active")},
		}

		CuberiteServerRequest(data)
	}()
}

// CuberiteServerRequest send a POST request that will be handled
// by our Cuberite Docker plugin.
func CuberiteServerRequest(data url.Values) {
	client := &http.Client{}
	req, _ := http.NewRequest("POST", "http://127.0.0.1:8080/webadmin/Slack/Slack", strings.NewReader(data.Encode()))
	req.Header.Set("Content-Type", "application/x-www-form-urlencoded")
	req.SetBasicAuth("admin", "admin")
	client.Do(req)
}
