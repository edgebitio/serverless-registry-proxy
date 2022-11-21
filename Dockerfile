FROM golang:1.19.2-alpine AS build

RUN apk add --no-cache git ca-certificates
WORKDIR /src/app
COPY . .
RUN go build -o /app

FROM alpine
# This pulls in a Lamdba adapter to take any HTTP container and make it work unmodified
COPY --from=public.ecr.aws/awsguru/aws-lambda-adapter:0.5.0 /lambda-adapter /opt/extensions/lambda-adapter
RUN apk add --no-cache ca-certificates
COPY --from=build /app /app

ENTRYPOINT [ "/app" ]
