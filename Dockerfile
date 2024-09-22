# # syntax=docker/dockerfile:1

# FROM --platform=$BUILDPLATFORM mcr.microsoft.com/dotnet/sdk:8.0-alpine AS build

# COPY . /source
# WORKDIR /source/AspireApp1.AppHost

# ARG TARGETARCH

# # Install ICU for globalization if needed
# RUN apk add --no-cache icu-libs
# ENV DOTNET_SYSTEM_GLOBALIZATION_INVARIANT=false

# RUN dotnet workload install aspire

# # Build the application based on architecture
# RUN  dotnet publish -c Release -o out

# FROM mcr.microsoft.com/dotnet/aspnet:8.0-alpine AS final
# WORKDIR /app

# COPY --from=build /app .

# USER $APP_UID

# ENTRYPOINT ["dotnet", "AspireApp1.AppHost.dll"]

# Base image for .NET SDK to build the project
FROM mcr.microsoft.com/dotnet/sdk:8.0 AS build
WORKDIR /app

# Copy everything and restore dependencies
COPY . ./
RUN dotnet restore

# Build the project
RUN dotnet build --configuration Release --no-restore

# Publish the project
RUN dotnet publish --configuration Release --no-restore -o /app/publish

# Runtime image
FROM mcr.microsoft.com/dotnet/aspnet:8.0 AS runtime
WORKDIR /app
COPY --from=build /app/publish ./

# Expose the required ports
EXPOSE 80
EXPOSE 443

# Run the application
ENTRYPOINT ["dotnet", "AspireApp1.dll"]

