FROM debian:bookworm
RUN apt update && apt install python3-pip python3-numpy python3-flask openssh-server -y && rm -rf /var/lib/apt
COPY app.py /app.py
EXPOSE 5000 22
ENTRYPOINT ["python", "./app.py"]
