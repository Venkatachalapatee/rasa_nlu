FROM python:3.5-slim

# Run updates, install basics and cleanup
# - build-essential: Compile specific dependencies
# - git-core: Checkout git repos
RUN apt-get update -qq && apt-get install -y --no-install-recommends \
  build-essential \
  git-core && \
  apt-get clean && \
  rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

RUN pip install git+https://github.com/mit-nlp/MITIE.git --no-cache-dir
RUN pip install tflearn tensorflow nltk --no-cache-dir

ENV RASA_NLU_DOCKER="YES" \
    RASA_NLU_HOME=/app \
    RASA_NLU_PYTHON_PACKAGES=/usr/local/lib/python3.5/dist-packages

WORKDIR ${RASA_NLU_HOME}

COPY ./requirements.txt requirements.txt

# Split into pre-requirements, so as to allow for Docker build caching
RUN pip install $(tail -n +2 requirements.txt)

#VOLUME ["${RASA_NLU_HOME}", "${RASA_NLU_PYTHON_PACKAGES}"]

ADD . ${RASA_NLU_HOME}

RUN python setup.py install

RUN ls /app

#EXPOSE 5000
#
#ENTRYPOINT ["./entrypoint.sh"]
#CMD ["help"]
