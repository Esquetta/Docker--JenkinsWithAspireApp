# Use the .NET 8.0 SDK base image
FROM mcr.microsoft.com/dotnet/sdk:8.0 AS build

# Set working directory
WORKDIR /app

# Copy the project files
COPY ".csproj .

# Restore the dependencies
RUN dotnet publish --no-restore -c Release -o out

# Restore missing workloads (add this step)
RUN dotnet workload restore

FROM mcr.microsoft.com/dotnet/sdk:8.0
WORKDIR /app
COPY --from=build /app .
ENTRYPOINT [ "dotnet" ,"AspireApp1.AppHost.dll"]
