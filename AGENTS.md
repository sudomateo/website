# Agent Guidelines for Hugo Website

## Build Commands
- `hugo` - Build the site to `public/` directory
- `hugo server` - Start development server with live reload
- `hugo --buildDrafts` - Build including draft content
- `hugo --destination <dir>` - Build to custom directory
- `docker build -t website .` - Build containerized version

## Content Structure
- Posts: `content/posts/<slug>/index.md` with frontmatter in TOML format
- Pages: `content/<page>.md` for standalone pages
- Static assets: `static/` directory for images, favicons, etc.
- Archetypes: Use `archetypes/default.md` template for new content

## Content Style Guidelines
- Use TOML frontmatter (between `+++` markers)
- Required fields: `title`, `description`, `summary`, `date`, `publishDate`, `lastmod`
- Optional fields: `keywords`, `categories`, `tags`, `featureAlt`, `aliases`
- Set `draft = false` for published content
- Use ISO 8601 date format with timezone (e.g., `2023-07-28T23:00:00-04:00`)

## File Organization
- Each post in its own directory: `content/posts/<slug>/`
- Main content file: `index.md`
- Post images: Store alongside `index.md` (e.g., `feature.jpg`)
- Use descriptive, kebab-case directory names for posts

## Hugo Configuration
- Main config: `config/_default/config.toml`
- Uses Congo theme via Hugo Modules (no local theme directory)
- Base URL: `https://matthewsanabria.dev`
- Pagination: 10 items per page
- Outputs: HTML, RSS, JSON for home page