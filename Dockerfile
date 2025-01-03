# Use the .NET SDK image for building the application
FROM mcr.microsoft.com/dotnet/sdk:9.0 AS build
WORKDIR /app


# Copy the project file and restore dependencies
COPY AzureContainerDotNet/. ./AzureContainerDotNet/
WORKDIR /app/AzureContainerDotNet
RUN dotnet restore

# Copy the source code and publish the application
RUN dotnet publish -c Release -o /app/publish

# Use the ASP.NET Core runtime for the final image
FROM mcr.microsoft.com/dotnet/aspnet:9.0 AS runtime
WORKDIR /app
COPY --from=build /app/publish .

# Expose the default ASP.NET Core port
EXPOSE 80

# Set the entry point
ENTRYPOINT ["dotnet", "AzureContainerDotNet.dll"]