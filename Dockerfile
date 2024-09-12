# syntax=docker/dockerfile:1

FROM --platform=$BUILDPLATFORM mcr.microsoft.com/dotnet/sdk:8.0-alpine AS build

COPY . /source
WORKDIR /source/AspireApp1.AppHost

ARG TARGETARCH

# Install ICU for globalization if needed
RUN apk add --no-cache icu-libs
ENV DOTNET_SYSTEM_GLOBALIZATION_INVARIANT=false

# Build the application based on architecture
RUN --mount=type=cache,id=nuget,target=/root/.nuget/packages \
    if [ "$TARGETARCH" = "amd64" ]; then \
        dotnet publish -r linux-x64 --use-current-runtime --self-contained false -o /app; \
    else \
        dotnet publish -r linux-$TARGETARCH --use-current-runtime --self-contained false -o /app; \
    fi

FROM mcr.microsoft.com/dotnet/aspnet:8.0-alpine AS final
WORKDIR /app

COPY --from=build /app .

USER $APP_UID

ENTRYPOINT ["dotnet", "AspireApp1.AppHost.dll"]
