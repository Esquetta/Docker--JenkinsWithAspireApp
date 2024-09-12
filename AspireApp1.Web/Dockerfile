# See https://aka.ms/customizecontainer to learn how to customize your debug container and how Visual Studio uses this Dockerfile to build your images for faster debugging.

# This stage is used when running from VS in fast mode (Default for Debug configuration)
FROM mcr.microsoft.com/dotnet/sdk:8.0 AS build-env

WORKDIR /app

COPY *.csproj .


RUN dotnet restore

COPY . ./

RUN dotnet publish --no-restore -c Release -o out
FROM mcr.microsoft.com/dotnet/aspnet:8.0 

WORKDIR /app
COPY --from=build-env /app/out .
ENTRYPOINT ["dotnet", "AspireApp1.Web.dll"]



# # This stage is used to build the service project
# FROM mcr.microsoft.com/dotnet/sdk:8.0 AS build
# ARG BUILD_CONFIGURATION=Release
# WORKDIR /src
# COPY ["AspireApp1.Web/AspireApp1.Web.csproj", "AspireApp1.Web/"]
# COPY ["AspireApp1.ServiceDefaults/AspireApp1.ServiceDefaults.csproj", "AspireApp1.ServiceDefaults/"]
# RUN dotnet restore "./AspireApp1.Web/AspireApp1.Web.csproj"
# COPY . .
# WORKDIR "/src/AspireApp1.Web"
# RUN dotnet build "./AspireApp1.Web.csproj" -c $BUILD_CONFIGURATION -o /app/build

# # This stage is used to publish the service project to be copied to the final stage
# FROM build AS publish
# ARG BUILD_CONFIGURATION=Release
# RUN dotnet publish "./AspireApp1.Web.csproj" -c $BUILD_CONFIGURATION -o /app/publish /p:UseAppHost=false

# # This stage is used in production or when running from VS in regular mode (Default when not using the Debug configuration)
# FROM base AS final
# WORKDIR /app
# COPY --from=publish /app/publish .
# ENTRYPOINT ["dotnet", "AspireApp1.Web.dll"]