FROM public.ecr.aws/gravitational/teleport-distroless:16.0.4

ENTRYPOINT ["tctl"]
CMD ["users", "reset", "${ADMIN_USER}"]