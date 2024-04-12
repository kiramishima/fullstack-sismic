FROM ruby:latest

RUN mkdir /app
ADD ./api_sisms /app/
WORKDIR /app

# Bundle install
RUN ls
RUN bundle install
ENV PORT=3000
EXPOSE 3000

CMD ["bundle", "exec", "puma", "-p", "3000"]
