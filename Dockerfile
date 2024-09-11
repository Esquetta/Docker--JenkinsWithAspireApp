# Use the .NET 8.0 SDK base image
FROM mcr.microsoft.com/dotnet/sdk:8.0 AS build

# Set working directory
WORKDIR /src

# Copy the project files
COPY ["AspireApp1.AppHost.csproj", "./"]

# Restore the dependencies
RUN --mount=type=cache,id=nuget,target=/root/.nuget/packages \
    dotnet restore

# Restore missing workloads (add this step)
RUN dotnet workload restore

# Copy the rest of your application
COPY . .

# Publish the application for the specified architecture (use x64 for amd64 architecture)
RUN --mount=type=cache,id=nuget,target=/root/.nuget/packages \
    dotnet publish -a x64 --use-current-runtime --self-contained false -o /app
