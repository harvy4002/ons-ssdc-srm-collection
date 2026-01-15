FROM ovhcom/venom

VOLUME /workdir/results
VOLUME /workdir/tests

WORKDIR /workdir

ENV VENOM_OUTPUT_DIR=/workdir/results
ENV VENOM_LIB_DIR=/workdir/tests/lib
ENV VENOM_VERBOSE=1

# Override the default entrypoint so that we can run it ourselves after deploying the container
ENTRYPOINT []
