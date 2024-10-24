module StudentMarketplace::StudentData {

    use aptos_framework::signer;
    use aptos_framework::coin;
    use aptos_framework::aptos_coin::AptosCoin;

    // Struct representing student data.
    struct StudentData has store, key {
        owner: address,
        price: u64,
        data: vector<u8>,
    }

    // Function to create a new student data entry.
    public fun create_data(owner: &signer, price: u64, data: vector<u8>) {
        let student_data = StudentData {
            owner: signer::address_of(owner),
            price,
            data,
        };
        move_to(owner, student_data);
    }

    // Function to purchase student data.
    public fun purchase_data(buyer: &signer, seller: address, amount: u64) acquires StudentData {
        let data = borrow_global_mut<StudentData>(seller);
        assert!(amount >= data.price, 1);

        // Transfer the payment from the buyer to the seller.
        let payment = coin::withdraw<AptosCoin>(buyer, amount);
        coin::deposit<AptosCoin>(data.owner, payment);

        // Transfer data ownership to the buyer.
        data.owner = signer::address_of(buyer);
    }
}
