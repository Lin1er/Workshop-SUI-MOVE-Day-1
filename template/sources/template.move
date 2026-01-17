module template::template;

use sui::event;
use sui::random::{Self, Random};

// For Move coding conventions, see
// https://docs.sui.io/concepts/sui-move-concepts/conventions

// ================================
// ERROR CODES
// ================================
// Mendefinisikan error codes untuk validasi
// Best practice: gunakan prefix E untuk error constants
const EInvalidYear: u64 = 0;
const EColorEmpty: u64 = 1;

// ================================
// EVENTS
// ================================
// Events digunakan untuk logging on-chain yang dapat di-subscribe oleh off-chain services
// Event struct harus memiliki atribut 'copy' dan 'drop'

public struct CarCreated has copy, drop {
    car_id: ID,
    car_type: u8,
    engine_power: u64,
    owner: address,
}

public struct CarColorUpdated has copy, drop {
    car_id: ID,
    old_color: vector<u8>,
    new_color: vector<u8>,
}

public struct CarUpgraded has copy, drop {
    car_id: ID,
    new_engine_power: u64,
}

public struct CarDestroyed has copy, drop {
    car_id: ID,
    owner: address,
}

// ================================
// OBJECT DEFINITIONS
// ================================
// Define New Object
// Struct digunakan untuk mendifinisikan struktur data dari object yang akan kita buat atau gunakan
// perlu diperhatikan bahwa setiap struct yang didefinisikan di Move harus memiliki atribut aksesibilitas 'public'
// dan perlu diketahui bahwa setiap object di Move harus memiliki atribut 'key' sehingga harus memiliki field 'id' bertipe 'UID'
// juga object di move dapat memiliki beberapa atribut lainnya sesuai kebutuhan seperti 'store', 'drop', dan 'copy'.
// Atribut 'store' memungkinkan object untuk disimpan di dalam storage, 'drop' memungkinkan object untuk dihapus,
// dan 'copy' memungkinkan object untuk disalin.
// Berikut adalah contoh definisi struct untuk object baru bernama 'Car' dengan field:
// - id: UID (wajib ada untuk setiap object)
// - type: String (tipe mobil)
// - color: String (warna mobil)
// - year: u16 (tahun pembuatan mobil)

public enum CarType has copy, drop, store {
    Sedan,
    SUV,
    Truck,
    Coupe,
    Convertible,
}

public enum EnginePower has copy, drop, store {
    Low, // 1000cc
    Medium, // 2000cc
    High, // 3000cc
}

public struct Car has key, store {
    id: UID,
    car_type: CarType,
    engine: EnginePower,
    color: vector<u8>,
    year: u16,
}

// ================================
// HELPER FUNCTIONS (Internal)
// ================================
// Fungsi helper untuk konversi enum ke nilai numerik
// Fungsi ini tidak memiliki 'public' sehingga hanya dapat dipanggil dari dalam module

fun car_type_to_u8(car_type: &CarType): u8 {
    match (car_type) {
        CarType::Sedan => 0,
        CarType::SUV => 1,
        CarType::Truck => 2,
        CarType::Coupe => 3,
        CarType::Convertible => 4,
    }
}

fun engine_power_to_u64(engine: &EnginePower): u64 {
    match (engine) {
        EnginePower::Low => 1000,
        EnginePower::Medium => 2000,
        EnginePower::High => 3000,
    }
}

fun u8_to_car_type(value: u8): CarType {
    if (value == 0) {
        CarType::Sedan
    } else if (value == 1) {
        CarType::SUV
    } else if (value == 2) {
        CarType::Truck
    } else if (value == 3) {
        CarType::Coupe
    } else {
        CarType::Convertible
    }
}

fun u8_to_engine_power(value: u8): EnginePower {
    if (value == 0) {
        EnginePower::Low
    } else if (value == 1) {
        EnginePower::Medium
    } else {
        EnginePower::High
    }
}

// ================================
// ENTRY FUNCTIONS
// ================================
// Entry functions adalah fungsi yang dapat dipanggil langsung dari transaction
// Entry functions harus memiliki visibility 'public' atau 'entry'

// Lalu dilanjutkan dengan membuat fungsi lainnya yang berfungsi untuk mengelola object tersebut atau operasi yang dapat dilakukan pada object tersebut
// pada contoh kali ini kita akan membuat beberapa fungsi yaitu:
// 1. create_car: Fungsi ini digunakan untuk membuat object Car baru dengan parameter warna, dan tahun pembuatan mobil. untuk type dan EnginePower akan ditentukan secara random atau mengikuti sistem gacha
// 2. update_color: Fungsi ini digunakan untuk mengubah warna mobil pada object Car yang sudah ada
// 3. upgrade_engine: Fungsi ini digunakan untuk meningkatkan engine power mobil
// 4. destroy_car: Fungsi ini digunakan untuk menghapus/membakar object Car
// 5. transfer_car: Fungsi ini digunakan untuk mentransfer kepemilikan mobil ke alamat lain

/// Fungsi untuk membuat mobil baru dengan sistem gacha
/// CarType dan EnginePower akan ditentukan secara random
/// Parameter:
/// - r: Random object dari Sui framework (shared object)
/// - color: Warna mobil dalam bentuk bytes (contoh: b"Red", b"Blue")
/// - year: Tahun pembuatan mobil
/// - ctx: Transaction context
entry fun create_car(r: &Random, color: vector<u8>, year: u16, ctx: &mut TxContext) {
    // Validasi input
    assert!(year >= 1900 && year <= 2026, EInvalidYear);
    assert!(color.length() > 0, EColorEmpty);

    // Generate random values untuk gacha system
    let mut generator = random::new_generator(r, ctx);
    let random_type = random::generate_u8_in_range(&mut generator, 0, 4);
    let random_engine = random::generate_u8_in_range(&mut generator, 0, 2);

    let car_type = u8_to_car_type(random_type);
    let engine = u8_to_engine_power(random_engine);

    let car = Car {
        id: object::new(ctx),
        car_type,
        engine,
        color,
        year,
    };

    // Emit event untuk tracking
    event::emit(CarCreated {
        car_id: object::id(&car),
        car_type: car_type_to_u8(&car.car_type),
        engine_power: engine_power_to_u64(&car.engine),
        owner: ctx.sender(),
    });

    // Transfer mobil ke pembuat (sender)
    transfer::transfer(car, ctx.sender());
}

/// Fungsi alternatif untuk membuat mobil dengan tipe dan engine yang spesifik
/// Berguna untuk testing atau admin purposes
/// Parameter:
/// - car_type_value: 0=Sedan, 1=SUV, 2=Truck, 3=Coupe, 4=Convertible
/// - engine_value: 0=Low(1000cc), 1=Medium(2000cc), 2=High(3000cc)
/// - color: Warna mobil
/// - year: Tahun pembuatan
/// - ctx: Transaction context
entry fun create_car_custom(
    car_type_value: u8,
    engine_value: u8,
    color: vector<u8>,
    year: u16,
    ctx: &mut TxContext,
) {
    // Validasi input
    assert!(year >= 1900 && year <= 2026, EInvalidYear);
    assert!(color.length() > 0, EColorEmpty);

    let car_type = u8_to_car_type(car_type_value % 5);
    let engine = u8_to_engine_power(engine_value % 3);

    let car = Car {
        id: object::new(ctx),
        car_type,
        engine,
        color,
        year,
    };

    event::emit(CarCreated {
        car_id: object::id(&car),
        car_type: car_type_to_u8(&car.car_type),
        engine_power: engine_power_to_u64(&car.engine),
        owner: ctx.sender(),
    });

    transfer::transfer(car, ctx.sender());
}

/// Fungsi untuk mengubah warna mobil
/// Hanya pemilik mobil yang dapat mengubah warna
/// Parameter:
/// - car: Reference mutable ke object Car
/// - new_color: Warna baru
entry fun update_color(car: &mut Car, new_color: vector<u8>) {
    assert!(new_color.length() > 0, EColorEmpty);

    let old_color = car.color;
    car.color = new_color;

    event::emit(CarColorUpdated {
        car_id: object::id(car),
        old_color,
        new_color: car.color,
    });
}

/// Fungsi untuk upgrade engine mobil
/// Engine hanya bisa di-upgrade, tidak bisa di-downgrade
/// Low -> Medium -> High
/// Parameter:
/// - car: Reference mutable ke object Car
entry fun upgrade_engine(car: &mut Car) {
    let new_engine = match (&car.engine) {
        EnginePower::Low => EnginePower::Medium,
        EnginePower::Medium => EnginePower::High,
        EnginePower::High => EnginePower::High, // Already max, stay the same
    };

    car.engine = new_engine;

    event::emit(CarUpgraded {
        car_id: object::id(car),
        new_engine_power: engine_power_to_u64(&car.engine),
    });
}

/// Fungsi untuk menghapus/membakar mobil
/// Object akan dihancurkan dan tidak dapat dikembalikan
/// Parameter:
/// - car: Object Car yang akan dihapus (ownership transferred)
/// - ctx: Transaction context
entry fun destroy_car(car: Car, ctx: &TxContext) {
    let Car { id, car_type: _, engine: _, color: _, year: _ } = car;

    event::emit(CarDestroyed {
        car_id: id.to_inner(),
        owner: ctx.sender(),
    });

    object::delete(id);
}

/// Fungsi untuk mentransfer kepemilikan mobil ke alamat lain
/// Parameter:
/// - car: Object Car yang akan ditransfer
/// - recipient: Alamat penerima
///
/// Note: Kita suppress warning 'custom_state_change' karena fungsi ini memang
/// sengaja dibuat sebagai wrapper untuk kemudahan user. Object dengan ability
/// 'store' tetap bisa di-transfer langsung menggunakan public_transfer.
#[allow(lint(custom_state_change))]
entry fun transfer_car(car: Car, recipient: address) {
    transfer::transfer(car, recipient);
}

// ================================
// VIEW FUNCTIONS (Getters)
// ================================
// View functions digunakan untuk membaca data dari object
// Fungsi ini tidak mengubah state dan mengembalikan nilai

/// Mendapatkan tipe mobil
public fun get_car_type(car: &Car): &CarType {
    &car.car_type
}

/// Mendapatkan engine power
public fun get_engine(car: &Car): &EnginePower {
    &car.engine
}

/// Mendapatkan warna mobil
public fun get_color(car: &Car): &vector<u8> {
    &car.color
}

/// Mendapatkan tahun pembuatan
public fun get_year(car: &Car): u16 {
    car.year
}

/// Mendapatkan engine power dalam bentuk numerik (cc)
public fun get_engine_power_value(car: &Car): u64 {
    engine_power_to_u64(&car.engine)
}

/// Mendapatkan tipe mobil dalam bentuk numerik
public fun get_car_type_value(car: &Car): u8 {
    car_type_to_u8(&car.car_type)
}

/// Cek apakah mobil adalah tipe tertentu
public fun is_sedan(car: &Car): bool {
    match (&car.car_type) {
        CarType::Sedan => true,
        _ => false,
    }
}

public fun is_suv(car: &Car): bool {
    match (&car.car_type) {
        CarType::SUV => true,
        _ => false,
    }
}

/// Cek apakah engine sudah maksimal
public fun is_max_engine(car: &Car): bool {
    match (&car.engine) {
        EnginePower::High => true,
        _ => false,
    }
}
