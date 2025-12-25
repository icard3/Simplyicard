FROM mcr.microsoft.com/dotnet/sdk:9.0 AS build-backend
WORKDIR /src
COPY ["Bookstore.Api/Bookstore.Api.csproj", "Bookstore.Api/"]
RUN dotnet restore "Bookstore.Api/Bookstore.Api.csproj"
COPY Bookstore.Api/. Bookstore.Api/
WORKDIR "/src/Bookstore.Api"
RUN dotnet build "Bookstore.Api.csproj" -c Release -o /app/build
RUN dotnet publish "Bookstore.Api.csproj" -c Release -o /app/publish

FROM node:18 AS build-frontend
WORKDIR /app
COPY bookstore-frontend/package*.json ./
RUN npm install
COPY bookstore-frontend/. .
RUN npm run build

FROM mcr.microsoft.com/dotnet/aspnet:9.0
WORKDIR /app
COPY --from=build-backend /app/publish .
COPY --from=build-frontend /app/build ./wwwroot
EXPOSE 8080
ENV ASPNETCORE_URLS=http://+:8080
ENTRYPOINT ["dotnet", "Bookstore.Api.dll"]
