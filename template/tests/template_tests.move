#[test_only]
module template::template_tests;

use sui::random::{Self, Random};
use sui::test_scenario::{Self as ts, Scenario};
use template::template::{Self, Car};

// ================================
// TEST CONSTANTS
// ================================
const ALICE: address = @0xA11CE;
const BOB: address = @0xB0B;

// ================================
// HELPER FUNCTIONS
// ================================
fun setup_random(scenario: &mut Scenario) {
    random::create_for_testing(ts::ctx(scenario));
}

// ================================
// TEST: CREATE CAR CUSTOM
// ================================
#[test]
fun test_create_car_custom() {
    let mut scenario = ts::begin(ALICE);
    {
        template::create_car_custom(0, 0, b"Red", 2024, ts::ctx(&mut scenario));
    };
    ts::next_tx(&mut scenario, ALICE);
    {
        let car = ts::take_from_sender<Car>(&scenario);
        assert!(template::get_year(&car) == 2024);
        assert!(template::get_car_type_value(&car) == 0);
        assert!(template::get_engine_power_value(&car) == 1000);
        assert!(template::is_sedan(&car) == true);
        assert!(template::is_max_engine(&car) == false);
        ts::return_to_sender(&scenario, car);
    };
    ts::end(scenario);
}

#[test]
fun test_create_suv_high_engine() {
    let mut scenario = ts::begin(ALICE);
    {
        template::create_car_custom(1, 2, b"Black", 2025, ts::ctx(&mut scenario));
    };
    ts::next_tx(&mut scenario, ALICE);
    {
        let car = ts::take_from_sender<Car>(&scenario);
        assert!(template::get_car_type_value(&car) == 1);
        assert!(template::get_engine_power_value(&car) == 3000);
        assert!(template::is_suv(&car) == true);
        assert!(template::is_max_engine(&car) == true);
        ts::return_to_sender(&scenario, car);
    };
    ts::end(scenario);
}

// ================================
// TEST: UPDATE COLOR
// ================================
#[test]
fun test_update_color() {
    let mut scenario = ts::begin(ALICE);
    {
        template::create_car_custom(0, 0, b"Red", 2024, ts::ctx(&mut scenario));
    };
    ts::next_tx(&mut scenario, ALICE);
    {
        let mut car = ts::take_from_sender<Car>(&scenario);
        assert!(*template::get_color(&car) == b"Red");
        template::update_color(&mut car, b"Blue");
        assert!(*template::get_color(&car) == b"Blue");
        ts::return_to_sender(&scenario, car);
    };
    ts::end(scenario);
}

// ================================
// TEST: UPGRADE ENGINE
// ================================
#[test]
fun test_upgrade_engine_low_to_medium() {
    let mut scenario = ts::begin(ALICE);
    {
        template::create_car_custom(0, 0, b"Red", 2024, ts::ctx(&mut scenario));
    };
    ts::next_tx(&mut scenario, ALICE);
    {
        let mut car = ts::take_from_sender<Car>(&scenario);
        assert!(template::get_engine_power_value(&car) == 1000);
        template::upgrade_engine(&mut car);
        assert!(template::get_engine_power_value(&car) == 2000);
        ts::return_to_sender(&scenario, car);
    };
    ts::end(scenario);
}

#[test]
fun test_upgrade_engine_medium_to_high() {
    let mut scenario = ts::begin(ALICE);
    {
        template::create_car_custom(0, 1, b"Red", 2024, ts::ctx(&mut scenario));
    };
    ts::next_tx(&mut scenario, ALICE);
    {
        let mut car = ts::take_from_sender<Car>(&scenario);
        assert!(template::get_engine_power_value(&car) == 2000);
        template::upgrade_engine(&mut car);
        assert!(template::get_engine_power_value(&car) == 3000);
        assert!(template::is_max_engine(&car) == true);
        ts::return_to_sender(&scenario, car);
    };
    ts::end(scenario);
}

#[test]
fun test_upgrade_engine_max_stays_max() {
    let mut scenario = ts::begin(ALICE);
    {
        template::create_car_custom(0, 2, b"Red", 2024, ts::ctx(&mut scenario));
    };
    ts::next_tx(&mut scenario, ALICE);
    {
        let mut car = ts::take_from_sender<Car>(&scenario);
        assert!(template::get_engine_power_value(&car) == 3000);
        template::upgrade_engine(&mut car);
        assert!(template::get_engine_power_value(&car) == 3000);
        ts::return_to_sender(&scenario, car);
    };
    ts::end(scenario);
}

// ================================
// TEST: TRANSFER CAR
// ================================
#[test]
fun test_transfer_car() {
    let mut scenario = ts::begin(ALICE);
    {
        template::create_car_custom(0, 0, b"Red", 2024, ts::ctx(&mut scenario));
    };
    ts::next_tx(&mut scenario, ALICE);
    {
        let car = ts::take_from_sender<Car>(&scenario);
        template::transfer_car(car, BOB);
    };
    ts::next_tx(&mut scenario, BOB);
    {
        let car = ts::take_from_sender<Car>(&scenario);
        assert!(template::get_year(&car) == 2024);
        ts::return_to_sender(&scenario, car);
    };
    ts::end(scenario);
}

// ================================
// TEST: DESTROY CAR
// ================================
#[test]
fun test_destroy_car() {
    let mut scenario = ts::begin(ALICE);
    {
        template::create_car_custom(0, 0, b"Red", 2024, ts::ctx(&mut scenario));
    };
    ts::next_tx(&mut scenario, ALICE);
    {
        let car = ts::take_from_sender<Car>(&scenario);
        template::destroy_car(car, ts::ctx(&mut scenario));
    };
    ts::next_tx(&mut scenario, ALICE);
    {
        assert!(!ts::has_most_recent_for_sender<Car>(&scenario), 0);
    };
    ts::end(scenario);
}

// ================================
// TEST: CREATE CAR WITH RANDOM (GACHA)
// ================================
#[test]
fun test_create_car_gacha() {
    let mut scenario = ts::begin(@0x0);
    setup_random(&mut scenario);
    ts::next_tx(&mut scenario, ALICE);
    {
        let random = ts::take_shared<Random>(&scenario);
        template::create_car(&random, b"Silver", 2025, ts::ctx(&mut scenario));
        ts::return_shared(random);
    };
    ts::next_tx(&mut scenario, ALICE);
    {
        let car = ts::take_from_sender<Car>(&scenario);
        let car_type = template::get_car_type_value(&car);
        let engine = template::get_engine_power_value(&car);
        assert!(car_type <= 4, 0);
        assert!(engine == 1000 || engine == 2000 || engine == 3000, 1);
        assert!(template::get_year(&car) == 2025);
        ts::return_to_sender(&scenario, car);
    };
    ts::end(scenario);
}

// ================================
// TEST: VALIDATION ERRORS
// ================================
// Note: Menggunakan numeric value karena error constants dari module lain tidak bisa di-reference langsung
// EInvalidYear = 0, EColorEmpty = 1

#[test, expected_failure]
fun test_invalid_year_too_old() {
    let mut scenario = ts::begin(ALICE);
    {
        template::create_car_custom(0, 0, b"Red", 1800, ts::ctx(&mut scenario));
    };
    ts::end(scenario);
}

#[test, expected_failure]
fun test_invalid_year_too_new() {
    let mut scenario = ts::begin(ALICE);
    {
        template::create_car_custom(0, 0, b"Red", 2030, ts::ctx(&mut scenario));
    };
    ts::end(scenario);
}

#[test, expected_failure]
fun test_empty_color() {
    let mut scenario = ts::begin(ALICE);
    {
        template::create_car_custom(0, 0, b"", 2024, ts::ctx(&mut scenario));
    };
    ts::end(scenario);
}

#[test, expected_failure]
fun test_update_empty_color() {
    let mut scenario = ts::begin(ALICE);
    {
        template::create_car_custom(0, 0, b"Red", 2024, ts::ctx(&mut scenario));
    };
    ts::next_tx(&mut scenario, ALICE);
    {
        let mut car = ts::take_from_sender<Car>(&scenario);
        template::update_color(&mut car, b"");
        ts::return_to_sender(&scenario, car);
    };
    ts::end(scenario);
}

// ================================
// TEST: ALL CAR TYPES
// ================================
#[test]
fun test_all_car_types() {
    let mut scenario = ts::begin(ALICE);

    // Sedan (0)
    { template::create_car_custom(0, 0, b"Red", 2024, ts::ctx(&mut scenario)); };
    ts::next_tx(&mut scenario, ALICE);
    {
        let car = ts::take_from_sender<Car>(&scenario);
        assert!(template::is_sedan(&car) == true);
        ts::return_to_sender(&scenario, car);
    };

    // SUV (1)
    ts::next_tx(&mut scenario, ALICE);
    { template::create_car_custom(1, 0, b"Blue", 2024, ts::ctx(&mut scenario)); };
    ts::next_tx(&mut scenario, ALICE);
    {
        let car = ts::take_from_sender<Car>(&scenario);
        assert!(template::is_suv(&car) == true);
        assert!(template::get_car_type_value(&car) == 1);
        ts::return_to_sender(&scenario, car);
    };

    // Truck (2)
    ts::next_tx(&mut scenario, ALICE);
    { template::create_car_custom(2, 0, b"Green", 2024, ts::ctx(&mut scenario)); };
    ts::next_tx(&mut scenario, ALICE);
    {
        let car = ts::take_from_sender<Car>(&scenario);
        assert!(template::get_car_type_value(&car) == 2);
        ts::return_to_sender(&scenario, car);
    };

    // Coupe (3)
    ts::next_tx(&mut scenario, ALICE);
    { template::create_car_custom(3, 0, b"Yellow", 2024, ts::ctx(&mut scenario)); };
    ts::next_tx(&mut scenario, ALICE);
    {
        let car = ts::take_from_sender<Car>(&scenario);
        assert!(template::get_car_type_value(&car) == 3);
        ts::return_to_sender(&scenario, car);
    };

    // Convertible (4)
    ts::next_tx(&mut scenario, ALICE);
    { template::create_car_custom(4, 0, b"Purple", 2024, ts::ctx(&mut scenario)); };
    ts::next_tx(&mut scenario, ALICE);
    {
        let car = ts::take_from_sender<Car>(&scenario);
        assert!(template::get_car_type_value(&car) == 4);
        ts::return_to_sender(&scenario, car);
    };

    ts::end(scenario);
}
