# syntax=docker/dockerfile:1

FROM --platform=$BUILDPLATFORM mcr.microsoft.com/dotnet/sdk:8.0-alpine AS build

COPY . /source
WORKDIR /source/AspireApp1.AppHost

ARG TARGETARCH

# Install ICU for globalization if needed
RUN apk add --no-cache icu-libs
ENV DOTNET_SYSTEM_GLOBALIZATION_INVARIANT=false

RUN dotnet workload install aspire

# Build the application based on architecture
RUN  dotnet publish -c Release -o out

FROM mcr.microsoft.com/dotnet/aspnet:8.0-alpine AS final
WORKDIR /app

COPY --from=build /source .

# USER $APP_UID

ENTRYPOINT ["dotnet", "AspireApp1.AppHost.dll"]




