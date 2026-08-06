# My Healthy Map

Find your next healthy spot. My Healthy Map helps people discover food,
fitness & wellness spots near them — wherever they are in the city — and
builds a personal map around their own health goals.

Rails app generated with [lewagon/rails-templates](https://github.com/lewagon/rails-templates), created by the [Le Wagon coding bootcamp]team.

Live at: https://www.myhealthymap.com/

## What it does

### AI coach
A built-in AI coach (powered by the OpenAI API) helps users find spots that
match what they're looking for. Users add their own health goals, then
discuss them with the coach — the conversation shapes the recommendations
they get, instead of browsing a generic list.

### Health goals
Users set their own goals in their own words rather than picking from a
fixed list. Those goals feed directly into conversations with the coach, so
guidance stays personal to what each user is actually trying to achieve.

### Map with categories
The core experience is a Mapbox-powered map of spots, filterable by
category: **food, fitness, wellness**.

### Saved spots
Users can save spots they want to remember or come back to, building their
own personal shortlist over time instead of re-searching the same area
repeatedly.

### Share
Spots can be shared with others — a quick way for a user to pass along a
recommendation without the recipient needing to search from scratch.

## Stack

- **Rails** 7.1
- **PostgreSQL**
- **Mapbox** for the map
- **Devise** for authentication
- **OpenAI API** for the coach

## Install / Setup

1. `bundle install`
2. `bin/rails db:migrate`
3. Set required environment variables (see below)
4. `bin/rails server`

## Environment variables

- `MAPBOX_TOKEN` (confirm exact var name used in your app)
- `OPENAI_API_KEY`
- `DATABASE_URL` (production)
- Devise secret / Rails master key, as usual

## Deployment (Heroku)

```bash
git push heroku main
```

Heroku picks up the push, runs `bundle install` and `assets:precompile`
automatically as part of the build. Make sure `OPENAI_API_KEY` and
`MAPBOX_TOKEN` are set on Heroku itself:

```bash
heroku config:set OPENAI_API_KEY=xxxxx
heroku config:set MAPBOX_TOKEN=xxxxx
```

Run any pending migrations after a deploy that includes schema changes:

```bash
heroku run rails db:migrate
```
