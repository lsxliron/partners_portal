# iCapital Partners Portal

## How to Run the Project

### Prerequisites

- Elixir 1.18 (tested with 1.18.3 OTP-27)
- Postgresql (tested with 14.7)

### Steps

1. Clone the repository
1. Install dependencies: `mix deps.get`
1. Setup Postgres credentials:  
   you can use the default credentials or use
   custom ones by the setting environment
   variables (the provided values are the current defaults)

   ```sh
   export POSTGRES_USERNAME=postgres
   export POSTGRES_PASSWORD=postgres
   export POSTGRES_DATABASE=i_capital_dev
   export POSTGRES_HOST=localhost
   export POSTGRES_PORT=5432
   ```

1. Apply the database migrations

   ```sh
   mix ecto.migrate
   ```

1. Run the development server

   ```sh
   iex -S mix phx.server
   ```

1. Open your browser and navigate to `localhost:4000`

## Project Statement

Create a web application where users can create client records and upload documents.

## Approach

The application is implemented using Phoenix LiveView. I find it to be a great
web framework for Elixir (which is amazing by itself).

It provides many features out of the box including an ORM (`Ecto`),
code generators, and authentication modules which I did use in this project.

- The data is modeled as a single table where an investor may upload one or
  more documents (up to 10) for each client.
- Every time a new client is created, its files are being uploaded to the
  server and the client information is saved in the table
- The table has a `records` column which contains
  the full path to the uploaded files
- Investors are required to sign up before logging in to the system
- Investors may edit an existing record or delete it

## If I did have more time

1. Fixing the broken unittests
1. Better error handling when uploading files
1. Better UI/ UX - the look and feel should be slick and modern.
   The current UI state is not great
1. Data rendering - currently, records are being rendered where
   files are just comma separated.
   Ideally, we provide the user with a list containing the filenames
   with a download link and a quick preview
1. Uploaded files should be stored in different folders. That will prevent a
   scenario where one user overrides another user files. This could easily
   be achieved by using UUIDs
   as file names (keeping a flat folder). However, the downside is that
   filenames are no longer meaningful to humans.
1. From authentication standpoint - users should not be able to sign up
   to the system without an invitation link (or code).
1. From authorization standpoint - users should only be able to view data
   that was created by them. Currently, all data is visible to all logged in users.
   Furthermore, the system should have roles such as admin, editor and viewer
   to prevent data manipulation by unauthorized users

For production deployment

1. I would create a CI/CD pipeline to package the
   application and bake it into a Docker image that can run on Kubernetes or Docker
1. For a larger team of developers (i.e. more that 2), I would
   create a `docker-compose` file
   that will run the system locally. That makes it easy to get up and running quickly
1. Incorporate observability tools (e.g Sentry, OpenTelemetry) for monitoring,
   metrics collection and tracing. That makes it significantly easier
   to track and fix bugs.
