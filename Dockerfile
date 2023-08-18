FROM debian:bookworm
RUN apt update && apt install python3-pip python3-numpy openssh-server -y && rm -rf /var/lib/apt
RUN pip install flask
COPY app.py /app.py
EXPOSE 5000 22
ENTRYPOINT ["python", "./app.py"]
