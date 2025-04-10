# Background Jobs API (Rails + Sidekiq + ActiveJob)

This project is a simple, production-style **Rails API-only application** using the latest version of Rails. It demonstrates how to implement and test:

- Background job processing with **Sidekiq** and **ActiveJob**
- **User authentication** via `devise` and `devise-jwt`
- Sending welcome emails using ActionMailer
- Scraping a website and summarizing content using an AI model
- Fetching and reporting stock market data from a free API
- A mix of **event-based** and **cron-triggered** jobs

---

## 🔧 Tech Stack

- Ruby on Rails (API mode, latest)
- Redis (for Sidekiq)
- PostgreSQL
- Sidekiq + ActiveJob
- Devise + JWT for auth
- Nokogiri (web scraping)
- [Alpha Vantage or Financial Modeling Prep](https://financialmodelingprep.com/developer/docs/) for stock data
- `rufus-scheduler` for cron-style scheduling

---

## ⚙️ Setup Instructions

### 1. Clone the repository

```bash
git clone https://github.com/YOUR_USERNAME/background_jobs_api.git
cd background_jobs_api
```

### 2. Install dependencies
```bash
bundle install
yarn install --check-files
```

### 3. Setup the database
```bash
rails db:setup
```

### 4. Setup Rails credentials (JWT secret)
```bash
EDITOR="code --wait" bin/rails credentials:edit
```

Paste the following (replace with a real secret):

You can generate one with:
```bash
rails secret
```

Then, in the credentials file, add:
```yaml
jwt_secret_key: YOUR_GENERATED_SECRET_HERE
```

### 5. Start Redis and Sidekiq
```bash
brew services start redis
bundle exec sidekiq
```

### 6. Start Rails server (with dev tools)
```bash
bin/dev
```

## ✅ How to Test It Locally

### 🔐 1. Create a user and get JWT

```bash
curl -i -X POST http://localhost:3000/users \
  -H "Content-Type: application/json" \
  -d '{"user":{"email":"test@example.com", "password":"password"}}'
```
This will return a JWT token in the response. Use this token for authentication in subsequent requests.
Copy the Authorization header value (your JWT).

### 📨 2. Test welcome email job (runs automatically on sign-up)

Check sidekiq logs to confirm job processed:
```bash
bundle exec sidekiq
```
You should see SendWelcomeEmailJob completed successfully.
Check your email using letter opener web by visiting:
```bash
http://localhost:3000/letter_opener
```

To Check the sidekiq console
```bash
http://localhost:3000/sidekiq
```

### 🧠 3. Trigger the Scrape & Summarize Job

Make an authenticated request:
```bash
curl -X POST http://localhost:3000/scrape_and_summarize \
  -H "Content-Type: application/json" \
  -H "Authorization: Bearer YOUR_JWT_TOKEN_HERE" \
  -d '{"url": "https://example.com"}'
```

Sidekiq will scrape the page and run summarization logic.

## 🛠 Manual Testing Flow

Task	Command or Endpoint	Sidekiq Worker
Create user	/users	SendWelcomeEmailJob
Scrape site	/scrape_and_summarize	ScrapeAndSummarizeJob
Stock report	/stock_report	StockReportJob

Make sure to monitor Sidekiq logs for job success or failure.

## 🧵 Future Improvements

- Add RSpec tests for job triggering and results
- Swap rufus-scheduler with sidekiq-scheduler for robust cron jobs
- AI summarization integration with OpenAI or HuggingFace
- Better retry and error handling in jobs

## 🧑‍💻 Author

Created by Arturo Alvarez. Feel free to fork and extend!

```yaml

---

Would you like me to generate this file and add it to your project automatically, or help you publish this project on GitHub with an MIT license and full structure?
# License: MIT
```