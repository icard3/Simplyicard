FROM mcr.microsoft.com/dotnet/sdk:9.0 AS build
WORKDIR /src
COPY ["Bookstore.Api.csproj", "./"]
RUN dotnet restore "Bookstore.Api.csproj"
COPY . .
RUN dotnet build "Bookstore.Api.csproj" -c Release -o /app/build

FROM build AS publish
RUN dotnet publish "Bookstore.Api.csproj" -c Release -o /app/publish /p:UseAppHost=false

FROM mcr.microsoft.com/dotnet/aspnet:9.0 AS final
WORKDIR /app
COPY --from=publish /app/publish .
ENTRYPOINT ["dotnet", "Bookstore.Api.dll"]
