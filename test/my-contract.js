const { expect } = require("chai");
const { ethers } = require("hardhat");

const toWei = (_amount) => ethers.utils.parseEther(_amount.toString());
const fromWei = (_amount) => ethers.utils.formatEther(_amount.toString());

describe("MyContract", async () => {
	let deployer, user1, user2;

	beforeEach(async () => {
		[deployer, user1, user2] = await ethers.getSigners();
		const MyContract = await ethers.getContractFactory("MyContract");
		this.contract = await MyContract.connect(deployer).deploy();
	});

	describe("deployment", () => {
		it("should deploy contract properly", async () => {
			expect(this.contract.address).not.null;
			expect(this.contract.address).not.undefined;
		});
	});

	describe("getEtherPrice()", () => {
		const _etherPrice = toWei(4000);

		beforeEach(async () => {
			await this.contract.connect(user1).getEtherPrice();
			await this.contract.connect(deployer).execute(_etherPrice);
		});

		it("should get Ether price", async () => {
			expect(await this.contract.EtherPrice()).to.equal(_etherPrice);
		});

		it("should emit RequestEtherPrice event", async () => {
			expect(await this.contract.connect(user1).getEtherPrice())
				.to.emit(this.contract, "RequestEtherPrice")
				.withArgs(user1.address, "0");
		});

		it("should emit UpdateEtherPrice event", async () => {
			expect(await this.contract.connect(deployer).execute(_etherPrice))
				.to.emit(this.contract, "UpdateEtherPrice")
				.withArgs(_etherPrice);
		});

		it("should revert price update if caller doesn't have role", async () => {
			await expect(
				this.contract.connect(user1).execute(_etherPrice)
			).to.be.revertedWith("OracleBase: Access revoked for caller");
		});
	});
});
