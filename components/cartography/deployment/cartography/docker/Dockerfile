FROM python:3.7

WORKDIR /src

# Setup app user
RUN addgroup --gid 27100 --system app
RUN adduser --shell /bin/false --uid 27100 --ingroup app --system app
RUN chown -R app:app /src

# Install dependencies
COPY requirements.txt /src
RUN python -m pip install --upgrade pip
RUN pip3 install --upgrade -r /src/requirements.txt

# Add entrypoint
COPY docker-entrypoint.sh /
RUN chmod +x /docker-entrypoint.sh

USER app
ENTRYPOINT ["/docker-entrypoint.sh"]
