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
	"github.com/Sirupsen/logrus"
)

func main() {
	fmt.Println("start slack")

	if len(os.Args) > 1 {
		if len(os.Args) == 2 {
			reqPath := "http://127.0.0.1:8000/" + os.Args[1]
			resp, err := http.Get(reqPath)
			if err != nil {
				logrus.Println("Error on request:", reqPath, "ERROR:", err.Error())
			} else {
				logrus.Println("Request sent", reqPath, "StatusCode:", resp.StatusCode)
			}
		}
		return
	}

	http.HandleFunc("/containers", listContainers)
	http.ListenAndServe(":8000", nil)
}

// listContainers handles and reply to http requests having the path "/containers"
func listContainers(w http.ResponseWriter, r *http.Request) {

	// answer right away to avoid dead locks in LUA
	io.WriteString(w, "OK")

	email := os.Getenv("SORACOM_EMAIL")
	pass := os.Getenv("SORACOM_PASSWORD")
	c, err := goracom.NewClient(email, pass)
	if err != nil {
		logrus.Println(err.Error())
		return
	}
	s := c.NewSubscriber()
	ss, _ := s.FindAll()
	if err != nil {
		logrus.Println(err.Error())
		return
	}
	logrus.Println(ss)
	for _, sim := range *ss {
		go func() {
			data := url.Values{
				"action":    {"containerInfos"},
				"id":        {sim.IMSI},
				"name":      {sim.Tags["name"]},
				"imageRepo": {sim.SpeedClass},
				"imageTag":  {sim.ModuleType},
				"running":   {strconv.FormatBool(sim.Status == "active")},
			}

			CuberiteServerRequest(data)
		}()
	}
}

// CuberiteServerRequest send a POST request that will be handled
// by our Cuberite Docker plugin.
func CuberiteServerRequest(data url.Values) {
	client := &http.Client{}
	req, _ := http.NewRequest("POST", "http://127.0.0.1:8080/webadmin/Slack/Slack", strings.NewReader(data.Encode()))
	req.Header.Set("Content-Type", "application/x-www-form-urlencoded")
	req.SetBasicAuth("admin", "admin")
	_, err := client.Do(req)
	if err != nil {
		logrus.Println(err.Error())
		return
	}
}
