FROM golang:latest
RUN go get -u github.com/aws/aws-sdk-go &&\
	mkdir -pv src/github.com/moovel &&\
	cd src/github.com/moovel &&\
	git clone https://github.com/moovel/s3-download &&\
	cd s3-download &&\
	go build . &&\
	go install .
ENTRYPOINT ["s3-download"]
