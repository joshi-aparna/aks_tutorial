# aks_tutorial
The starting point to the code in this branch is the Microsoft document to create a simple ASP dotnet core web api that I found [here](https://learn.microsoft.com/en-us/aspnet/core/tutorials/min-web-api?view=aspnetcore-6.0&tabs=visual-studio-code). 

To run the code:
1. Clone the repository.
2. Switch to this branch: `git checkout start_here`
3. Start the app: `dotnet run`
4. On your browser, go to localhost: `https://localhost:<<portnumber>>/WeatherForecast`
The port number is printed on your console in step 3.

I used the `Docker` plugin to containerize the application
[!Docker extension screenshot](./docker_add_screenshot.jpg)

To test that things work fine in the containerized application, I created an image and ran it locally

1. `docker build -t aks_tutorial:v1 .`
2. List the docker images and check for the newly created image - `docker images`
3. Run the application: ` docker run -p 8080:5000 aks_tutorial:v1 ` - Note that `5000` is the port exposed in my Dockerfile
4. Go to browser and open `http://localhost:8080/WeatherForecast`



You now have a running dotnet core web-api that we will try to run on aks next.
