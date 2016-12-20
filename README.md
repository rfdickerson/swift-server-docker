# SwiftCrossCompile

Builds the Swift package for Linux and drops the executable in the present working directory.

## Build the Docker image

```
docker build --tag rfdickerson/swift-server-docker .
```

## Pull the image

You can get the image from Dockerhub here:

```
docker pull rfdickerson/swift-server-docker
```

## Run the compile

Move to the directory that contains the project you want to build. There should be a `Package.swift` file located there.

```
sudo docker run -v $PWD:/root/project -t -i rfdickerson/swift-builder:latest
```

