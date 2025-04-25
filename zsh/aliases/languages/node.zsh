alias n='npm'
alias ni='npm install'
alias nil='npm install --legacy-peer-deps'
alias nr='npm run'
alias ns='npm start'
alias nt='npm test'
alias nb='npm run build'
alias nrs='npm run-script'

alias nci='npm ci'
alias nd='npm run dev'

# Yarn aliases
alias y='yarn'
alias yi='yarn install'
alias ya='yarn add'
# alias nil='npm install --legacy-peer-deps'
alias yr='yarn run'
alias yd='yarn run dev'
alias ys='yarn run start'
alias yt='yarn run test'
alias yb='yarn run build'

nid() {
    npm install
    cenv
    npm run dev
}
