package main

import (
	"encoding/json"
	"fmt"
	"io/ioutil"
	"main/bean"
	"net/http"
	"os"
)

//type RecognitionResult struct {
//	state string `json:state`
//	res   string `json:res`
//}

func main() {
	//在运行这个程序之前，请保证手机和当前网络处于同一个网络内(这里注意，IP地址不能填localhost)
	server := http.Server{Addr: "192.168.43.244:82"}

	http.HandleFunc("/image_upload",
		func(writer http.ResponseWriter, request *http.Request) {
			fmt.Println("进入这个页面")
			writer.Header().Set("Content-Type", "application/json")

			isSuccess := false
			numBerRes := "待测试数字"

			//接收文件
			file, header, upErr := request.FormFile("upload")
			if upErr == nil {
				src := make([]byte, header.Size)
				//这里以读为例
				_, readErr := file.Read(src)
				wrErr := ioutil.WriteFile("1.jpg", src, os.ModePerm)
				if readErr == nil && wrErr == nil {

					//调用...

					//
					isSuccess = true
					//numBerRes=...
				}
			}

			res := bean.RecognitionResult{
				IsSuccess: isSuccess,
				Res:       numBerRes,
			}

			jsonStr, err := json.Marshal(res)

			if err == nil {
				writer.Write(jsonStr)
				fmt.Println(string(jsonStr))
			} else {
				fmt.Println(err)
			}
		})

	server.ListenAndServe()
}
