# NodeBB GHCR deployment files

These files build NodeBB assets in GitHub Actions and publish a prebuilt image:

`ghcr.io/uzbd/free-nodebb:latest`

## Important before uploading

1. Temporarily disable automatic deploys for the existing Render service. Its current Dockerfile deployment must not race with the new image workflow.
2. Upload the three files while preserving their paths:
   - `Dockerfile.ghcr`
   - `docker-entrypoint-wrapper.sh`
   - `.github/workflows/build-image.yml`
3. Commit them to the `main` branch.
4. Open GitHub → Actions → **Build and publish NodeBB image** and wait for a successful run.
5. The first GHCR package may be private. If so, open the package settings for `free-nodebb` and change visibility to **Public**.
6. Only after the workflow succeeds and the image is public, create a new Render Web Service using the existing image `ghcr.io/uzbd/free-nodebb:latest`.
7. Reuse the current Render environment variables. Do not paste secrets into GitHub or this chat.
8. Keep the old Render service until the new image-backed service starts successfully and the forum is tested.

## Notes

- The CI workflow uses a temporary MongoDB service only for asset compilation. It does not use your Atlas credentials.
- Your production MongoDB Atlas database remains configured through Render environment variables.
- Cloudflare R2 is intentionally not included.
- The workflow pins NodeBB to `v4.16.8`, matching the version observed in the deployment logs.
- The root `Dockerfile` is intentionally left unchanged so this package does not replace it.
- The workflow builds for `linux/amd64`, suitable for Render's standard x86_64 runtime.
