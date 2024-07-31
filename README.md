# `B3Nature`

B3Nature project uses ICP blockchain to create a tokenized platform for environmental protection. Sponsors and supporters can provide financial aid to users engaged in work through staking or donating., and verified participants engage in cleanup, animal treatment, and reforestation, earning tokens upon proof. AI integration ensures efficient verification and payments, and public voting determines rewards.

# Payment Process for B3Nature
The B3Nature program finds its financial sponsors quickly due to its transparency and the trust it builds within the community. Many people are already engaged in environmental activities, often without proper organization or compensation. This program offers a structured and rewarding way for individuals around the world to contribute to environmental protection.

## How It Works
Sponsorship and Donations: Financial backers and donors contribute funds to the program, supporting various environmental projects.
Staking and Voting: Users stake tokens to participate in the decision-making process, voting on proposals to ensure the projects align with community goals.
Proposal Approval: When a proposal, such as an environmental cleanup, reaches a certain threshold of support (e.g., 100 votes), it is automatically approved and token automaticly paid to user ,
Token Distribution: Upon successful completion and verification of the project, tokens are distributed to participants as rewards for their efforts.
This system not only ensures fair compensation for those working towards environmental goals but also enhances the program's credibility and appeal, drawing significant attention and participation.

## Future Capabilities
In future updates, the program will incorporate AI-based review of submitted evidence to verify content and prevent fraud before creating proposals for voting. This feature will automatically perform preliminary verification, controlling network traffic and ensuring that only valid proposals reach the voting stage. This not only enhances security but also streamlines the proposal process, making it more efficient and reliable.
# AI
the program will incorporate AI-based review of submitted evidence to verify content and prevent fraud before creating proposals for voting. This feature is designed to perform preliminary verification automatically, which will control network traffic and ensure that only valid proposals reach the voting stage. This not only enhances security but also streamlines the proposal process, making it more efficient and reliable.

# Team works
we will be able to organize structured cleanups, allowing individuals to form small teams or large groups dedicated to environmental cleanup and support activities. These teams will be able to:
Participate in organized cleanup efforts in various regions.
Receive rewards based on the extent and impact of their activities.
Collaborate and coordinate with other teams for more effective and widespread cleanup efforts.
Contribute to a cleaner environment through well-structured and transparent initiatives.
This feature will enhance the program by encouraging community engagement and providing incentives for collective action, ultimately leading to more significant and sustainable environmental impact.

## Key Features

- **Tokenization and Staking**: Users can stake tokens to sponsor environmental projects and earn rewards.
- **Verification and Rewards**: Participants can verify their identity, submit evidence of their contributions, and receive tokens as rewards.
- **Comprehensive Environmental Aid**: The platform supports a wide range of environmental initiatives beyond cleanup, including animal welfare and habitat restoration.

## Implementation

The project is being developed using the Motoko language, which is specifically designed for the Internet Computer. Below are the steps to set up and run the project.

To get started, you might want to explore the project directory structure and the default configuration file. Working with this project in your development environment will not affect any production deployment or identity tokens.

To learn more before you start working with `B3Nature`, see the following documentation available online:

- [Quick Start](https://internetcomputer.org/docs/current/developer-docs/setup/deploy-locally)
- [SDK Developer Tools](https://internetcomputer.org/docs/current/developer-docs/setup/install)
- [Motoko Programming Language Guide](https://internetcomputer.org/docs/current/motoko/main/motoko)
- [Motoko Language Quick Reference](https://internetcomputer.org/docs/current/motoko/main/language-manual)

If you want to start working on your project right away, you might want to try the following commands:

```bash
cd B3Nature/
dfx help
dfx canister --help
```

## Running the project locally

If you want to test your project locally, you can use the following commands:

```bash
# Starts the replica, running in the background
dfx start --background

# Deploys your canisters to the replica and generates your candid interface
dfx deploy
```

Once the job completes, your application will be available at `http://localhost:4943?canisterId={asset_canister_id}`.

If you have made changes to your backend canister, you can generate a new candid interface with

```bash
npm run generate
```

at any time. This is recommended before starting the frontend development server, and will be run automatically any time you run `dfx deploy`.

If you are making frontend changes, you can start a development server with

```bash
npm start
```

Which will start a server at `http://localhost:8080`, proxying API requests to the replica at port 4943.

## Team Members

current team members working on this project:

- **Bahamin Deylami**
  - [Forum Profile](https://forum.dfinity.org/u/bahamin1/summary)
    git : Bahamin1
- **Behrad Deylami**
  - [Forum Profile](https://forum.dfinity.org/u/b3hr4d/summary)
    git : b3hr4d

Together, we are committed to making a positive impact on our environment and society through innovative blockchain solutions.

## Contributing

We welcome contributions from the community. Please feel free to fork the repository and submit pull requests. For major changes, please open an issue first to discuss what you would like to change.

### Note on frontend environment variables

If you are hosting frontend code somewhere without using DFX, you may need to make one of the following adjustments to ensure your project does not fetch the root key in production:

- set`DFX_NETWORK` to `ic` if you are using Webpack
- use your own preferred method to replace `process.env.DFX_NETWORK` in the autogenerated declarations
  - Setting `canisters -> {asset_canister_id} -> declarations -> env_override to a string` in `dfx.json` will replace `process.env.DFX_NETWORK` with the string in the autogenerated declarations
- Write your own `createActor` constructor
