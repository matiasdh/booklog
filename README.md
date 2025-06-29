# 📚 BookLog

BookLog is a small social network made with **Ruby on Rails**, **Hotwire**, and **TailwindCSS**. It has the main features of a social feed and its design is clean and easy to use.

## 🎯 Why Was BookLog Made?

BookLog was created to:

- Build a full-stack MVP using Rails 8 and PostgreSQL
- Practicing Hotwire features: Turbo, Turbo Frames, and Stimulus
- Make a simple and responsive design with TailwindCSS
- Use complex relationships (followers, likes, comments)
- Add end-to-end tests with RSpec, FactoryBot

## 🛠️ Technologies

- **Ruby on Rails 8**
- **Hotwire** (Turbo + Stimulus)
- **TailwindCSS**
- **PostgreSQL**
- **Devise** (for login and authentication)
- **RSpec** and **FactoryBot**(for testing)

## 🔍 Main Features

- Register, log in, and log out (Devise)
- Create posts about books
- Like and comment on posts
- Follow and unfollow other users
- View eser profiles with follower and following counts
- See a feed with posts from users you follow

## 🔮 Future Plans

- Turbo Streams
- Search for users
- Upload profile images
- Improve the edit profile page
- Better support for mobile devices

## 🚀 How to Run BookLog Locally

1. Clone the repository:
    ```bash
    git clone https://github.com/yourusername/booklog.git
    cd booklog
    ```
2. Install dependencies:
    ```bash
    bundle install
    yarn install
    ```
3. Set up the database:
    ```bash
    rails db:setup
    ```
4. Start the app:
    ```bash
    bin/dev
    ```

Open [http://localhost:3000](http://localhost:3000) in your browser to use BookLog.
