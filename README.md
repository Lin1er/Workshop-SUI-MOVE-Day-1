# 🚗 Workshop Sui Move - Day 1

Repository materi workshop **Introduction to Sui & Move Programming Language**

> 📚 Materi ini mendukung **Modul 1: Introduction to Sui** dan **Modul 2: Introduction to Move**

## 📋 Tentang Workshop Ini

Repository ini berisi kode template dan contoh implementasi yang digunakan dalam workshop Sui Move Development. Peserta akan belajar fundamental Sui blockchain dan Move programming language melalui hands-on project pembuatan Car NFT dengan sistem gacha.

### 🎯 Learning Objectives

Setelah menyelesaikan workshop ini, peserta akan mampu:
- ✅ Memahami arsitektur dan konsep dasar Sui blockchain
- ✅ Mengerti object model dan ownership di Sui
- ✅ Menulis smart contract menggunakan Move language
- ✅ Mengimplementasikan NFT dengan custom logic
- ✅ Deploy dan interact dengan smart contract di Sui testnet
- ✅ Membuat dan menjalankan unit tests

### � Cakupan Materi

**Modul 1: Introduction to Sui**
- Arsitektur Sui blockchain
- Object model dan ownership
- Transaction structure
- Sui CLI basics

**Modul 2: Introduction to Move**
- Move syntax dan semantics
- Structs, abilities, dan enums
- Entry functions dan visibility
- Events dan error handling
- Random number generation
- Unit testing

## 🎮 Project Overview: Car NFT

Project ini mengimplementasikan sistem NFT mobil dengan fitur-fitur:
- **Gacha System**: Tipe mobil dan engine power ditentukan secara random
- **Customization**: Ubah warna mobil
- **Upgrade System**: Tingkatkan engine power mobil
- **Transfer & Destroy**: Kelola kepemilikan dan hapus NFT

## 🎯 Fitur Utama

### 1. Tipe Mobil (Random Gacha)
- 🚘 Sedan
- 🚙 SUV
- 🚚 Truck
- 🏎️ Coupe
- 🚗 Convertible

### 2. Engine Power (Random Gacha)
- ⚡ Low: 1000cc
- ⚡⚡ Medium: 2000cc
- ⚡⚡⚡ High: 3000cc

### 3. Operasi yang Tersedia
- ✅ Create Car (Random/Custom)
- 🎨 Update Color
- ⬆️ Upgrade Engine
- 🔄 Transfer Ownership
- 🗑️ Destroy Car

## 🛠️ Prasyarat

Sebelum mengikuti workshop, peserta diharapkan:

### Prerequisites Pengetahuan
- Pemahaman dasar programming (any language)
- Familiar dengan command line/terminal
- Konsep dasar blockchain (recommended)

### Software yang Harus Diinstall
- [Sui CLI](https://docs.sui.io/guides/developer/getting-started/sui-install) - versi terbaru
- [Git](https://git-scm.com/) - untuk clone repository
- Text Editor (VS Code recommended)

### Setup Sui Wallet
```bash
# Setup Sui client
sui client

# Generate wallet address
sui client new-address ed25519

# Switch ke testnet
sui client switch --env testnet

# Request faucet (untuk gas)
sui client faucet
```

## 📦 Setup Repository

### Untuk Peserta Workshop

1. Clone repository ini:
```bash
git clone <repository-url>
cd day1-SUI
```

2. Navigate ke folder template:
```bash
cd template
```

3. Verify instalasi dengan build project:
```bash
sui move build
```

Jika build berhasil, Anda siap mengikuti workshop! ✅

## 📖 Panduan Workshop

### Step 1: Explore Kode Template

File utama yang akan dipelajari:
- `template/sources/template.move` - Smart contract utama
- `template/tests/template_tests.move` - Unit tests
- `template/Move.toml` - Konfigurasi project

**Instruktur akan menjelaskan:**
- Struktur file Move
- Object definition dengan structs
- Enums untuk tipe data
- Entry functions
- Events system

### Step 2: Build Project

```bash
sui move build
```

Perhatikan output build dan dependencies yang di-download.

### Step 3: Run Tests

```bash
sui move test
```

Lihat bagaimana tests dijalankan dan hasilnya.

### Step 4: Deploy ke Testnet

```bash
sui client publish --gas-budget 100000000
```

**Penting:** Simpan Package ID setelah deployment!

### Step 5: Interact dengan Contract

Ikuti instruksi dari instruktur untuk:
- Create car dengan random gacha
- Update car properties
- Transfer ownership
- Test semua fungsi yang tersedia

## 🚀 Deployment

### Deploy ke Testnet

1. Pastikan Anda sudah memiliki Sui wallet dan faucet testnet:
```bash
sui client active-address
```

2. Deploy smart contract:
```bash
sui client publish --gas-budget 100000000
```

3. Simpan Package ID yang muncul setelah deployment berhasil.

## 💻 Cara Penggunaan

### 1. Create Car dengan Random Gacha

```bash
sui client call \
  --package <PACKAGE_ID> \
  --module template \
  --function create_car \
  --args <RANDOM_OBJECT_ID> \"Red\" 2024 \
  --gas-budget 10000000
```

**Parameter:**
- `RANDOM_OBJECT_ID`: Shared object Random dari Sui (dapat dilihat di explorer)
- `color`: Warna mobil (contoh: "Red", "Blue", "Black")
- `year`: Tahun pembuatan (1900-2026)

### 2. Create Car Custom (Tanpa Random)

```bash
sui client call \
  --package <PACKAGE_ID> \
  --module template \
  --function create_car_custom \
  --args 0 0 \"Blue\" 2025 \
  --gas-budget 10000000
```

**Parameter:**
- `car_type`: 0=Sedan, 1=SUV, 2=Truck, 3=Coupe, 4=Convertible
- `engine`: 0=Low(1000cc), 1=Medium(2000cc), 2=High(3000cc)
- `color`: Warna mobil
- `year`: Tahun pembuatan

### 3. Update Warna Mobil

```bash
sui client call \
  --package <PACKAGE_ID> \
  --module template \
  --function update_color \
  --args <CAR_OBJECT_ID> \"Green\" \
  --gas-budget 10000000
```

### 4. Upgrade Engine

```bash
sui client call \
  --package <PACKAGE_ID> \
  --module template \
  --function upgrade_engine \
  --args <CAR_OBJECT_ID> \
  --gas-budget 10000000
```

**Catatan:** Engine hanya bisa di-upgrade (Low → Medium → High), tidak bisa downgrade.

### 5. Transfer Mobil

```bash
sui client call \
  --package <PACKAGE_ID> \
  --module template \
  --function transfer_car \
  --args <CAR_OBJECT_ID> <RECIPIENT_ADDRESS> \
  --gas-budget 10000000
```

### 6. Destroy (Burn) Mobil

```bash
sui client call \
  --package <PACKAGE_ID> \
  --module template \
  --function destroy_car \
  --args <CAR_OBJECT_ID> \
  --gas-budget 10000000
```

## 🧪 Testing

Project ini dilengkapi dengan comprehensive test suite.

### Menjalankan Semua Test

```bash
sui move test
```

### Menjalankan Test Spesifik

```bash
sui move test test_create_car_custom
```

### Test Coverage

- ✅ Create car dengan custom parameters
- ✅ Create car dengan random gacha
- ✅ Update color
- ✅ Upgrade engine (Low → Medium → High)
- ✅ Transfer ownership
- ✅ Destroy car
- ✅ Error handling (invalid year, empty color, dll)

## 📁 Struktur Project

```
template/
├── Move.toml              # Konfigurasi project & dependencies
├── sources/
│   └── template.move      # Smart contract utama
├── tests/
│   └── template_tests.move # Unit tests
└── build/                 # Hasil build (auto-generated)
```

## 🔍 Konsep Penting yang Dipelajari

### Modul 1: Introduction to Sui

#### 1. **Sui Object Model**
```move
public struct Car has key, store {
    id: UID,              // Unique identifier
    car_type: CarType,    // Custom enum type
    engine: EnginePower,  // Power level
    color: vector<u8>,    // Mutable property
    year: u16,            // Immutable property
}
```
- Setiap object harus punya `id: UID`
- Abilities: `key`, `store`, `drop`, `copy`
- Ownership model di Sui

#### 2. **Transaction & Gas**
- Transaction structure
- Gas budget dan estimation
- Transaction effects

#### 3. **Events untuk Tracking**
```move
public struct CarCreated has copy, drop {
    car_id: ID,
    car_type: u8,
    engine_power: u64,
    owner: address,
}
```
- On-chain logging
- Off-chain indexing

### Modul 2: Introduction to Move

#### 1. **Enums (Move 2024)**
```move
public enum CarType has copy, drop, store {
    Sedan,
    SUV,
    Truck,
    Coupe,
    Convertible,
}
```

#### 2. **Pattern Matching**
```move
fun car_type_to_u8(car_type: &CarType): u8 {
    match (car_type) {
        CarType::Sedan => 0,
        CarType::SUV => 1,
        // ...
    }
}
```

#### 3. **Entry Functions**
- Public vs entry visibility
- Parameter validation
- Error handling dengan `assert!`

#### 4. **Random Number Generation**
```move
entry fun create_car(r: &Random, ...) {
    let mut generator = random::new_generator(r, ctx);
    let random_type = random::generate_u8_in_range(&mut generator, 0, 4);
}
```

#### 5. **View Functions (Getters)**
```move
public fun get_car_type(car: &Car): &CarType {
    &car.car_type
}
```

#### 6. **Ownership & Transfer**
```move
transfer::transfer(car, recipient);  // Transfer ownership
object::delete(id);                   // Destroy object
```

## 🧪 Testing di Move

### Test Structure
```move
#[test_only]
module template::template_tests;

#[test]
fun test_create_car_custom() {
    // Test implementation
}
```

### Running Tests
```bash
# Run all tests
sui move test

# Run specific test
sui move test test_create_car_custom

# Verbose output
sui move test -v
```

## � Exercises untuk Peserta

Setelah mengikuti penjelasan instruktur, coba tantangan berikut:

### Level 1: Basic
1. ✏️ Deploy contract dan create car dengan warna favorit kamu
2. ✏️ Update warna mobil menjadi warna lain
3. ✏️ Upgrade engine dari Low ke Medium

### Level 2: Intermediate
4. ✏️ Tambahkan fungsi `get_car_info()` yang return semua informasi mobil
5. ✏️ Buat event baru `CarTransferred` ketika mobil ditransfer
6. ✏️ Tambahkan validasi: warna tidak boleh sama ketika update

### Level 3: Advanced
7. ✏️ Implementasi sistem rarity (Common, Rare, Epic berdasarkan engine)
8. ✏️ Buat fungsi `merge_cars()` untuk combine 2 mobil jadi 1 dengan stats lebih tinggi
9. ✏️ Tambahkan cooldown system untuk upgrade engine

## 🎓 Untuk Instruktur

### Slide Deck Suggestions

**Modul 1: Introduction to Sui (30 menit)**
- Slide 1-5: Apa itu Sui? Kenapa Sui?
- Slide 6-10: Object model vs Account model
- Slide 11-15: Ownership & Transfer
- Slide 16-20: Demo: Sui Explorer & CLI

**Modul 2: Introduction to Move (45 menit)**
- Slide 1-5: Move language overview
- Slide 6-10: Syntax dasar & types
- Slide 11-15: Structs & abilities
- Slide 16-20: Functions & visibility
- Slide 21-25: Enums & pattern matching
- Slide 26-30: Testing
- Slide 31-35: Live coding: Car NFT

### Demo Flow
1. Show Sui Explorer (5 min)
2. Build & Test project (5 min)
3. Deploy ke testnet (5 min)
4. Create car & interact (10 min)
5. Explain code line-by-line (20 min)

### Common Questions

**Q: Kenapa pakai Move, bukan Solidity?**
A: Move dirancang untuk asset-centric programming dengan safety yang lebih tinggi. No reentrancy, no overflow, resource-oriented.

**Q: Apa bedanya Sui dengan blockchain lain?**
A: Object-centric model, parallel execution, instant finality (sub-second), dan developer experience yang lebih baik.

**Q: Apakah Move susah dipelajari?**
A: Syntaxnya mirip Rust, tapi konsepnya berbeda. Dengan workshop ini, peserta akan mendapat fondasi yang kuat.

## 🤝 Kontribusi

Untuk instruktur lain yang ingin menggunakan materi ini:
1. Fork repository ini
2. Sesuaikan dengan kebutuhan workshop Anda
3. Beri credit ke repository asli
4. Share improvements via Pull Request

## � Resources untuk Peserta

### Official Documentation
- [Sui Documentation](https://docs.sui.io/)
- [Move Book](https://move-language.github.io/move/)
- [Sui Move by Example](https://examples.sui.io/)

### Community & Support
- [Sui Discord](https://discord.gg/sui)
- [Sui Forum](https://forums.sui.io/)
- [Sui GitHub](https://github.com/MystenLabs/sui)

### Tools
- [Sui Explorer (Testnet)](https://suiscan.xyz/testnet/home)
- [Sui Wallet](https://chrome.google.com/webstore/detail/sui-wallet)
- [Sui TypeScript SDK](https://github.com/MystenLabs/sui/tree/main/sdk/typescript)

## 🐛 Troubleshooting

## 🐛 Troubleshooting

### Error: "Package dependency does not specify a published address"

Pastikan di `Move.toml` sudah ada published-at setelah deploy pertama kali:
```toml
[package]
published-at = "<PUBLISHED_PACKAGE_ID>"
```

### Error: "Insufficient gas"

Tingkatkan gas budget:
```bash
--gas-budget 100000000
```

### Sui CLI tidak ditemukan

Install ulang Sui CLI:
```bash
cargo install --locked --git https://github.com/MystenLabs/sui.git --branch testnet sui
```

### Random Object ID tidak ditemukan

Untuk testnet, gunakan shared Random object:
1. Buka [Sui Explorer](https://suiscan.xyz/testnet/home)
2. Cari "0x8" di search (Random object biasanya di sini)
3. Atau tanya instruktur untuk Random object ID yang benar

### Build gagal dengan error "edition not supported"

Update Sui CLI ke versi terbaru yang support Move 2024.

## 📞 Support

### Selama Workshop
- Angkat tangan atau gunakan chat jika ada pertanyaan
- Instruktur dan asisten siap membantu
- Jangan ragu bertanya, no stupid questions!

### Setelah Workshop
- Join Sui Discord untuk diskusi
- Check dokumentasi official
- Explore lebih banyak examples di Sui GitHub

## 📝 Feedback

Feedback peserta sangat berharga! Setelah workshop:
- Isi form feedback (akan dibagikan oleh instruktur)
- Suggestions untuk improvement
- Share pengalaman belajar Anda

---

## 📄 License & Credits

Workshop material by [Your Name/Organization]

Project ini dibuat untuk tujuan edukasi dan learning.

**Happy Learning! 🚀**

_"The best way to learn is by building"_

---

### 📅 Workshop Timeline Suggestion

**Total: ~2 jam**

- 00:00-00:30 → Modul 1: Introduction to Sui
- 00:30-01:15 → Modul 2: Introduction to Move  
- 01:15-01:30 → Break ☕
- 01:30-01:50 → Live Coding & Demo
- 01:50-02:00 → Q&A & Closing

### 🎯 Next Steps After Workshop

1. **Practice**: Deploy your own variations
2. **Read**: Sui documentation & Move book
3. **Build**: Start your own Sui project
4. **Connect**: Join Sui community
5. **Share**: Teach others what you learned

**Continue Learning:**
- Workshop Day 2: Advanced Move Patterns
- Workshop Day 3: Frontend Integration with Sui SDK
- Workshop Day 4: Building Full DApp on Sui
