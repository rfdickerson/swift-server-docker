# Swift on the Server Image

Builds the Swift package for Linux and drops the executable in the present working directory.


## Pull the image

Before you use the image, you will need to pull it down. You can get the image from Dockerhub here:

```bash
docker pull rfdickerson/swift-server-docker
```

## Run the compile

First, change to the directory that contains the project you want to build. For example, there should be a `Package.swift` file located there and a Sources directory. 

Run the container:

```bash
docker run -v $PWD:/root/project -t -i rfdickerson/swift-server-docker:latest ACTION
```

1. Build - Builds project
2. Test - Runs the Swift test cases
3. Debug - Opens a lldb-server at :1234
4. Run - Runs the server on port 8090

Here, the $PWD is mounted to `/root/project` and opens port 8090.

## Build the Docker image

If you plan on developing with this image, use:

```bash
docker build --tag rfdickerson/swift-server-docker .
```



