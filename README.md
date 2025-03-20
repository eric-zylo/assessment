# Assessment Project

This project is a full-stack application built with Next.js and Ruby on Rails.

## Tech Stack

### Frontend (Next.js)

* Framework: Next.js
* Bundler: Turbopack
* Language: JavaScript
* State Management: React Redux (Redux Toolkit)
* Styling: Tailwind CSS
* API Communication: axios
* Deployment: Vercel
* Version Control: Git (GitHub)
* Package Manager: npm

### Backend (Rails API)

* Framework: Ruby on Rails (API-only)
* Language: Ruby
* Database: PostgreSQL
* API Style: RESTful API
* CORS: rack-cors gem
* Deployment: Render
* Version Control: Git (GitHub)
* Package Manager: Bundler

### General

* Environment variables for sensitive data.

## Deployment

* Frontend: Hosted on [Vercel](https://vercel.com/)
* Backend: Hosted on [Render](https://render.com/)

## Installation

1.  Clone the repository: `git clone https://github.com/eric-zylo/assessment.git`
2.  Navigate to the backend directory: `cd backend`
3.  Install dependencies: `bundle install`
4.  Create and migrate the database: `rails db:create && rails db:migrate`
5.  Navigate to the frontend directory: `cd ../frontend`
6.  Install dependencies: `npm install`
7.  Start the backend server: `rails server`
8.  Start the frontend server: `npm run dev`

## Usage

(Add instructions on how to use your application)

## API Documentation

(Add link to api documentation when created)

## License

This project is licensed under the MIT License. See [LICENSE](LICENSE) for details.

## Link to the hosted application (if there is one)

(Add link to hosted application when created)

## Description of the problem and solution

(Describe the problem your app solves and how it solves it)

## Reasoning behind your technical choices

(Explain why you chose the technologies you used)

## Describe how you would deploy this as a true production app on the platform of your choice:

### How would ensure the application is highly available and performs well?

(Describe your strategy for high availability and performance)

### How would you secure it?

* **JWT with HTTP-only Cookies:** Employ JWT authentication with HTTP-only cookies to securely manage user sessions. HTTP-only cookies prevent client-side JavaScript from accessing the authentication token, mitigating XSS attacks.
* **SameSite Attribute:** Utilize the `SameSite` attribute for cookies to protect against CSRF attacks. Setting it to `strict` or `lax` ensures that cookies are only sent in same-site or safe cross-site requests.
* **Secure Secret Key:** Store the JWT secret key securely using environment variables, and rotate it regularly.
* **HTTPS:** Enforce HTTPS to encrypt all communication between the client and server.
* **CORS Configuration:** Configure `rack-cors` to allow cross-origin requests only from trusted origins, preventing unauthorized access. Enable `credentials: true` for cookie handling.
* **Input Validation and Sanitization:** Implement robust input validation and sanitization to prevent injection attacks.
* **Authentication and Authorization:** Use Devise for user authentication and authorization, ensuring proper user management and access control.
* **Regular Security Audits:** Conduct regular security audits and penetration testing to identify and address potential vulnerabilities.
* **Update Dependencies:** Keep all dependencies up-to-date to patch security vulnerabilities.
* **Rate Limiting:** Implement rate limiting to protect against brute-force attacks.
* **Cookie Secure Flag:** In production, add the secure flag to the cookie.

### What would you add to make it easier to troubleshoot problems while it is running live?

(Describe your troubleshooting strategies)

## Trade-offs you might have made, anything you left out, or what you might do differently if you were to spend additional time on the project

(Describe any trade-offs or future improvements)

## Link to other code you're particularly proud of

(Add links to other projects)

## Link to your resume or public profile

(Add links to your resume or profile)
