# Meal generator

## 1. Running this project on local machine

Build an image:
```bash
docker-compose build
```

Install all the gems:
```bash
docker-compose run app bundle install
```

Setup test and development databases:

```bash
docker-compose run app bundle exec rails db:setup
```

Start Rails application server:

```bash
docker-compose up
```

The application will be available here: `http://localhost:3000`

## 2. Testing

For testing we are using Rspec. For runing all tests:
```bash
docker-compose run app bundle exec rspec spec
