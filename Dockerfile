FROM mcr.microsoft.com/dotnet/aspnet:8.0 AS base
USER $APP_UID
WORKDIR /app
EXPOSE 8080
EXPOSE 8081

FROM mcr.microsoft.com/dotnet/sdk:8.0 AS build
ARG BUILD_CONFIGURATION=Release
WORKDIR /src
COPY ["HelloWorldApp.fsproj", "./"]

RUN dotnet restore "HelloWorldApp.fsproj"
COPY . .
WORKDIR "/src/"
RUN dotnet build "HelloWorldApp.fsproj" -c $BUILD_CONFIGURATION -o /app/build

FROM build AS publish
ARG BUILD_CONFIGURATION=Release
RUN dotnet publish "HelloWorldApp.fsproj" -c $BUILD_CONFIGURATION -o /app/publish /p:UseAppHost=false

FROM base AS final
WORKDIR /app
COPY --from=publish /app/publish .
COPY ordsprak.txt /app/ordsprak.txt
ENTRYPOINT ["dotnet", "HelloWorldApp.dll"]
