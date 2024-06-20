FROM rust:1.79.0-bookworm as builder

ARG NTPD_RS_VERSION

RUN git clone https://github.com/pendulum-project/ntpd-rs --depth 1 --branch $NTPD_RS_VERSION /app/ntpd-rs
WORKDIR /app/ntpd-rs
RUN cargo build --release --locked

FROM debian:bookworm-slim AS runtime

ARG NTPD_RS_VERSION
LABEL org.opencontainers.image.title="ntpd-rs"
LABEL org.opencontainers.image.version="$NTPD_RS_VERSION"
LABEL org.opencontainers.image.authors="Whitestack <amacedo@whitestack.com>"
LABEL org.opencontainers.image.source="https://github.com/pendulum-project/ntpd-rs"
LABEL org.opencontainers.image.url="https://docs.ntpd-rs.pendulum-project.org/"
LABEL org.opencontainers.image.description="ntpd-rs packaged by Whitestack"

COPY --from=builder /app/ntpd-rs/target/release/ntp-daemon /usr/local/bin
COPY --from=builder /app/ntpd-rs/target/release/ntp-ctl /usr/local/bin
COPY --from=builder /app/ntpd-rs/target/release/ntp-metrics-exporter /usr/local/bin
ENTRYPOINT ["/usr/local/bin/ntp-daemon"]
