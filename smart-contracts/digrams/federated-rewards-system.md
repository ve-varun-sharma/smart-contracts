```mermaid
graph LR subgraph "Off-Chain (Web/App)" A[User Interface] -->|1. User Input: Ach. IDs/Reward Params| B(Web3 Library); B
-->|2. Encode Data, Sign Tx| C[RewardsManager Contract]; style A fill:#f9f,stroke:#333,stroke-width:2px style B
fill:#ccf,stroke:#333,stroke-width:2px end

    subgraph "On-Chain (Solidity)"
        C -->|3. Check Role| D{Role Management};
        C -->|4. Create Proposal Struct| E{Proposal Struct};
        C -->|5. Call Submission Fn| F{Proposal Submission};
        F -->|6. Save to Storage, emit event| C;
        C -->|7. Approval Threshold Met?| G{Proposal Approval/Execution};
        G -- Yes -->|8. Execute Handler| H[Handler Functions];
          G -- No --> C;


        subgraph "Handler Functions"
            H -->|9. Decode Data| HA[_handleNewAchievements]
            H -->|9. Decode Data| HB[_handleMintingStopped]
            H -->|9. Decode Data| HC[_handleRewardsProposal]
             H -->|9. Decode Data| HD[_handleRewardAdjustment]
            H -->|9. Decode Data| HE[_handleNftProposal]
            H -->|9. Decode Data| HF[_handleVelocityControl]

            HA --> |10. On Chain Storage Updates|I
            HB --> |10. On Chain Storage Updates|I
            HC --> |10. On Chain Storage Updates|I
             HD --> |10. On Chain Storage Updates|I
             HE --> |10. On Chain Storage Updates|I
            HF -->|10. On Chain Storage Updates|I

        end

        style C fill:#cfc,stroke:#333,stroke-width:2px
        style D fill:#ddd,stroke:#333,stroke-width:2px
        style E fill:#ddd,stroke:#333,stroke-width:2px
        style F fill:#ddd,stroke:#333,stroke-width:2px
        style G fill:#ddd,stroke:#333,stroke-width:2px
        style H fill:#ddd,stroke:#333,stroke-width:2px
        style HA fill:#eee,stroke:#333,stroke-width:1px
        style HB fill:#eee,stroke:#333,stroke-width:1px
         style HC fill:#eee,stroke:#333,stroke-width:1px
         style HD fill:#eee,stroke:#333,stroke-width:1px
         style HE fill:#eee,stroke:#333,stroke-width:1px
        style HF fill:#eee,stroke:#333,stroke-width:1px
    end
     subgraph "Data Storage (Implied)"
        I[Smart Contract Storage]
    end

    linkStyle default stroke:#333,stroke-width:1px

```
