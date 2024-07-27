// This is a generated Motoko binding.
// Please use `import service "ic:canister_id"` instead to call canisters on the IC if possible.

module {
  public type Account = { owner : Principal; subaccount : ?Blob };
  public type GetAccountIdentifierTransactionsArgs = {
    max_results : Nat64;
    start : ?Nat64;
    account_identifier : Text;
  };
  public type GetAccountIdentifierTransactionsError = { message : Text };
  public type GetAccountIdentifierTransactionsResponse = {
    balance : Nat64;
    transactions : [TransactionWithId];
    oldest_tx_id : ?Nat64;
  };
  public type GetAccountIdentifierTransactionsResult = {
    #Ok : GetAccountIdentifierTransactionsResponse;
    #Err : GetAccountIdentifierTransactionsError;
  };
  public type GetAccountTransactionsArgs = {
    max_results : Nat;
    start : ?Nat;
    account : Account;
  };
  public type GetBlocksRequest = { start : Nat; length : Nat };
  public type GetBlocksResponse = { blocks : [Blob]; chain_length : Nat64 };
  public type HttpRequest = {
    url : Text;
    method : Text;
    body : Blob;
    headers : [(Text, Text)];
  };
  public type HttpResponse = {
    body : Blob;
    headers : [(Text, Text)];
    status_code : Nat16;
  };
  public type InitArg = { ledger_id : Principal };
  public type Operation = {
    #Approve : {
      fee : Tokens;
      from : Text;
      allowance : Tokens;
      expected_allowance : ?Tokens;
      expires_at : ?TimeStamp;
      spender : Text;
    };
    #Burn : { from : Text; amount : Tokens; spender : ?Text };
    #Mint : { to : Text; amount : Tokens };
    #Transfer : {
      to : Text;
      fee : Tokens;
      from : Text;
      amount : Tokens;
      spender : ?Text;
    };
  };
  public type Status = { num_blocks_synced : Nat64 };
  public type TimeStamp = { timestamp_nanos : Nat64 };
  public type Tokens = { e8s : Nat64 };
  public type Transaction = {
    memo : Nat64;
    icrc1_memo : ?Blob;
    operation : Operation;
    timestamp : ?TimeStamp;
    created_at_time : ?TimeStamp;
  };
  public type TransactionWithId = { id : Nat64; transaction : Transaction };

};
