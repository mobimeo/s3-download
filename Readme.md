S3 Download
===

Welcome to S3 Download !

This fork is not an official Reach-Now product.

About
==

A simple tool to download objects from S3 on EC2 instances. It was written to retrieve private files via IAM rules for instances when bootstrapping machines. Written in go it can be used as an easily deployable alternative to other tools on reduced environments like CoreOS.

Usage
==

Arguments can be substituted with env variables (arguments prefixed by `S3_`, dashes are replaced by underscores). When a destination path is not provided the retrieved object will be written to stdout.

```
./s3-download -bucket mybucket -object-path somefile.txt -dest-path=/opt/somefile.txt -region eu-central-1
S3_REGION=eu-central-1 ./s3-download -bucket mybucket -object-path somefile.txt -dest-path=/opt/somefile.txt
```

## Dependencies
`s3-download` needs the following to retrieve config files from a S3 bucket:

- Valid `KMS` key to decrypt the file
- Read access to `moovel-ecs-config` S3 bucket

CFN Template Example (ECS TaskRole):
```
Policies:
  - PolicyName: !Sub ecs-task-${AWS::StackName}
    PolicyDocument:
      Version: "2012-10-17"
      Statement:
        # access to kms key for s3 decryption
        - Effect: Allow
          Action:
            - kms:Decrypt
          Resource:
            - !FindInMap [KMSKeys, !Ref ServiceEnvironment, Arn]
        # access to s3 bucket: moovel-ecs-config
        - Effect: Allow
          Action:
            - s3:GetObject
          Resource:
            - !Sub "arn:aws:s3:::moovel-ecs-config/search/${ServiceName}/*"
```

## Local Development
If you run a container locally (eg. on your notebook) with `s3-download` installed you will need to mount your aws credentials to the container so that they are available for `s3-download`.

Example:
```
docker run -it -v ${HOME}/.aws/credentials:/root/.aws/credentials moovel/georender:latest
```

Build
==

Go 1.5+ on OSX targetting linux:

```
go get -u github.com/aws/aws-sdk-go
GOOS=linux go build s3-download.go
```
