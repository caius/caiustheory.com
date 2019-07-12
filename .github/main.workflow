workflow "on pull request merge, delete the branch" {
  on = "pull_request"
  resolves = ["branch cleanup"]
}

action "branch cleanup" {
  uses = "jessfraz/branch-cleanup-action@master"
  secrets = ["GITHUB_TOKEN"]
}

workflow "Build and publish CaiusTheory" {
  on = "push"
  resolves = ["publish-caiustheory"]
}

action "branch-not-deleted" {
  uses = "actions/bin/filter@master"
  args = "not deleted"
}

action "build-caiustheory" {
  needs = "branch-not-deleted"
  uses = "peaceiris/actions-hugo@v0.55.6-1"
  args = ["--gc", "--minify", "--cleanDestinationDir"]
}

action "postprocess-caiustheory" {
  needs = "build-caiustheory"
  uses = "./.github/action/postprocess-caiustheory"
}

action "is-master" {
  needs = "postprocess-caiustheory"
  uses = "actions/bin/filter@master"
  args = "branch master"
}

action "publish-caiustheory" {
  needs = "is-master"
  uses = "peaceiris/actions-gh-pages@v1.0.1"
  env = {
    PUBLISH_DIR = "./public"
    PUBLISH_BRANCH = "gh-pages"
  }
  secrets = ["ACTIONS_DEPLOY_KEY"]
}
