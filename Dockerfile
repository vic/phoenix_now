FROM scratch
ADD rel/app /app

EXPOSE 4000
ENTRYPOINT ["/app"]
CMD ["foreground"]