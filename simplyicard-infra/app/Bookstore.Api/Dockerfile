FROM mcr.microsoft.com/dotnet/sdk:9.0 AS build
WORKDIR /src
COPY ["Bookstore.Api/Bookstore.Api.csproj", "Bookstore.Api/"]
RUN dotnet restore "Bookstore.Api/Bookstore.Api.csproj"
COPY . .
WORKDIR "/src/Bookstore.Api"
RUN dotnet build "Bookstore.Api.csproj" -c Release -o /app/build

FROM build AS publish
RUN dotnet publish "Bookstore.Api.csproj" -c Release -o /app/publish /p:UseAppHost=false

FROM mcr.microsoft.com/dotnet/aspnet:9.0 AS final
WORKDIR /app
COPY --from=publish /app/publish .
ENTRYPOINT ["dotnet", "Bookstore.Api.dll"]
