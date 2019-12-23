//
//  LsString.swift
//  Fiasy
//
//  Created by Eugen Lipatov on 10/7/19.
//  Copyright © 2019 Eugen Lipatov. All rights reserved.
//

import Foundation

public enum LS_STRING: String {
    
    case TAB_TITLE1 = "tab_title1"
    case TAB_TITLE2 = "tab_title2"
    case TAB_TITLE3 = "tab_title3"
    case TAB_TITLE4 = "tab_title4"
    
    case UNBOARDING_WELCOME = "unboarding_welcome"
    case UNBOARDING_FIRST_SCREEN = "unboarding_first_screen"
    case UNBOARDING_SECOND_SCREEN = "unboarding_second_screen"
    case UNBOARDING_THIRD_SCREEN = "unboarding_third_screen"
    case UNBOARDING_SKEEP = "unboarding_skeep"
    case UNBOARDING_NEXT = "unboarding_next"
    
    /*    Barcode Screen    */
    case BARCODE_TITLE_1 = "barcode_title_1"
    case BARCODE_TITLE_2 = "barcode_title_2"
    case BARCODE_TITLE_3 = "barcode_title_3"
    case BARCODE_TITLE_4 = "barcode_title_4"
    case BARCODE_TITLE_5 = "barcode_title_5"
    
    /*    Setting Screen    */
    case SETTINGS_HELP = "settings_items_help"
    case SETTINGS_PREMIUM = "settings_items_premium"
    case SETTINGS_PERSONAL = "settings_items_personal"
    case SETTINGS_INTAKE = "settings_items_intake"
    case SETTINGS_TITLE = "activity_profile_settings_settings"
    
    /*    Authorization Screen    */
    case OR = "or"
    case SIGN_IN = "signIn"
    case AUTHORIZATION_WITH = "authorization_with"
    case ACCOUNT_AVAILABLE = "account_available"
    case REGISTRATION_BY_MAIL = "registration_by_mail"
    
    /*    Sign In Screen    */
    case SIGN_IN_TITLE = "signIn_title"
    case LOGIN = "login"
    case PASSWORD = "password"
    case RESTORE = "restore"
    case FORGOT_PASSWORD = "forgot_password"
    case OR_SIGN_IN_BY = "or_signIn_by"
    case WRONG_DATA = "wrong_data"
    
    /*    Sign Up Screen    */
    case SIGN_UP_TITLE = "signUp_title"
    case WRITE_EMAIL = "write_email"
    case WRITE_PASSWORD = "write_password"
    case REPEAT_PASSWORD = "repeat_password"
    case SIMPLE_PASSWORD_ERROR = "simple_password_error"
    case PASSWORD_DONT_MATCH = "password_dont_match"
    case AGREE_WITH_CONDITIONS = "agree_with_conditions"
    case PRIVACY_POLICY = "privacy_policy"
    case USER_ALREADY_EXISTS = "user_already_exists"
    case NO_INTERNET_CONNECTION = "no_internet_connection"
    case ERROR = "error"
    
    /*    Privacy Policy Screen    */
    case PRIVACY_DESCRIPTION = "privacy_description"
    case SELECTED_PRODUCT_TITLE = "selected_products"
    
    /*    Reset Password Screen    */
    case RESET_SEND = "reset_send"
    case RESET_CLOSE_SCREEN = "reset_close_screen"
    case RESET_CLOSE_TITLE = "reset_close_title"
    case RESET_CLOSE_CONTINUE = "reset_close_continue"
    case RESET_CLOSE_DESCRIPTION = "reset_close_description"
    case WRONG_MAIL_ERROR = "wrong_mail_error"
    case RESET_PASSWORD_TITLE = "reset_password_title"
    case WE_SEND_EMAIL = "we_send_email"
    case ENTER_MAIL_DESCRIPTION = "enter_mail_description"
    case USER_DOES_NOT_EXIST = "user_does_not_exist"
    case CHECK_MAIL = "check_mail"
    case SENDED = "sended"
    
    case DIARY_MES_1 = "diary_mes_1"
    case DIARY_MES_2 = "diary_mes_2"
    case DIARY_MES_3 = "diary_mes_3"
    case DIARY_MES_4 = "diary_mes_4"
    case DIARY_MES_5 = "diary_mes_5"
    case DIARY_MES_6 = "diary_mes_6"
    case DIARY_MES_7 = "diary_mes_7" 
    case DIARY_MES_8 = "diary_mes_8"
    case DIARY_MES_9 = "diary_mes_9"
    case DIARY_MES_11 = "diary_mes_11"
    case DIARY_MES_12 = "diary_mes_12"
    
    
    /*    Interrogation Screen    */
    case SELECT_YOUR_GENDER = "select_your_gender"
    case SELECTED_MAN = "selected_man"
    case SELECTED_WOMAN = "selected_woman"
    case SELECT_YOUR_GROWTH = "select_your_growth"
    case GROWTH_UNIT = "growth_unit"
    case WEIGHT_UNIT = "weight_unit"
    case MIFFLIN_FORMULA = "mifflin_formula"
    case SELECT_YOUR_WEIGHT = "select_your_weight"
    case SELECT_YOUR_BIRTHDAY = "select_your_date_of_birth"
    case SELECT_YOUR_ACTIVITY = "select_your_activity"
    case FIRST_ACTIVITY = "first_activity"
    case SECOND_ACTIVITY = "second_activity"
    case THIRD_ACTIVITY = "third_activity"
    case FOURTH_ACTIVITY = "fourth_activity"
    case FIVE_ACTIVITY = "five_activity"
    case SIX_ACTIVITY = "six_activity"
    case SEVEN_ACTIVITY = "seven_activity"
    case SELECT_YOUR_TARGET = "select_your_target"
    case FIRST_TARGET = "first_target"
    case SECOND_TARGET = "second_target"
    case THIRD_TARGET = "third_target"
    case FOURTH_TARGET = "fourth_target"
    
    case ART_SERIES_TITLE = "art_series_series_title"
    case ART_SERIES_DAY = "art_series_day"
    case ART_SERIES_INFO = "art_series_series_info"
    case ART_SERIES_AUTHOR_TITLE = "art_series_author_title"
    case ART_SERIES_AUTHOR_BURLAKOV = "art_series_author_burlakov"
    case ART_SERIES_AUTHOR_BURLAKOV_BIO = "art_series_author_burlakov_bio"
    case ART_SERIES_AUTHOR_BURLAKOV_BIO2 = "art_series_author_burlakov_bio2"
    case ART_SERIES_AUTHOR_BURLAKOV_ACHIV1 = "art_series_author_burlakov_achiv1"
    case ART_SERIES_AUTHOR_BURLAKOV_ACHIV2 = "art_series_author_burlakov_achiv2"
    case ART_SERIES_AUTHOR_BURLAKOV_ACHIV3 = "art_series_author_burlakov_achiv3"
    
    /*    Interrogation Finish Screen    */
    case WAIT_A_WHILE = "wait_a_while"
    case WAIT_A_WHILE_DESCRIPTION = "wait_a_while_description"
    case PLAN_CALCULATED = "plan_calculated"
    case RECOMMENDED_RATE = "recommended_rate"
    case CALORIES_UNIT = "calories_unit"
    case GRAMS_UNIT = "grams_unit"
    case PROTEIN = "protein"
    case FAT = "fat"
    case CARBOHYDRATES = "carbohydrates"
    case IN_A_MONTH = "in_a_month"
    case FIRST_PIECE_DESCRIPTION = "first_piece_description"
    case SECOND_PIECE_DESCRIPTION = "second_piece_description"
    case TEXT_START_SEARCH = "text_start_search"
    case BARCODE_TITLE = "barCode_title"
    case PATTERNS_TITLE = "patterns_title"
    case MY_DISHES_TITLE = "my_dishes_title"
    case MY_PRODUCTS_TITLE = "my_products_title"

    /*    Premium Screen    */
    case PAY_DESCRIPTION_1 = "pay_description_1"
    case PAY_DESCRIPTION_2 = "pay_description_2"
    case LONG_PREM_OPEN = "long_prem_open"
    case MANY_MOUNTH = "many_mounth"
    case TITLE_SAVE_PERCENT = "title_save_percent"
    case TITLE_SAVE_PERCENT2 = "title_save_percent2"
    case BLACK_PREM_HOURS = "black_prem_hours"
    case BLACK_PREM_MINUTES = "black_prem_minutes"
    case BLACK_PREM_SECONDS = "black_prem_seconds"
    case BLACK_PREM_END = "black_prem_end"
    case LONG_PREM_TITL_1 = "long_prem_titl_1"
    case LONG_PREM_FEATURES_DIARY = "long_prem_features_diary"
    case LONG_PREM_FEATURES_ELEMENTS = "long_prem_features_elements"
    case LONG_PREM_FEATURES_RECIPE = "long_prem_features_recipe"
    case LONG_PREM_FEATURES_ARTICLES = "long_prem_features_articles"
    case LONG_PREM_FEATURES_STATISTIC = "long_prem_features_statistic"
    case LONG_PREM_FEATURES_BODY = "long_prem_features_body"
    case LONG_PREM_FEATURES_BUY = "buy"
    case PREMIUM_TITLE_NEW_1 = "premium_title_new_1"
    case PREMIUM_TITLE_NEW_2 = "premium_title_new_2"

    case LONG_PREM_EASY = "long_prem_easy"
    case LONG_PREM_ARTICLE_TITLE = "long_prem_article_title"
    case LONG_PREM_ARTICLE_TXT = "long_prem_article_txt"
    case LONG_PREM_RECIPE_TITLE = "long_prem_recipe_title"
    case LONG_PREM_RECIPE_TXT = "long_prem_recipe_txt"
    case LONG_PREM_SETTINGS_TITLE = "long_prem_settings_title"
    case LONG_PREM_SETTINGS_TXT = "long_prem_settings_txt"
    case LONG_PREM_PLANS_TITLE = "long_prem_plans_title"
    case LONG_PREM_PLANS_TXT = "long_prem_plans_txt"
    case LONG_PREM_MEASURE_TITLE = "long_prem_measure_title"
    case LONG_PREM_MEASURE_TXT = "long_prem_measure_txt"
    
    case MEASURING_TITLE1 = "measuring_title_1"
    case MEASURING_TITLE2 = "measuring_title_2"
    case MEASURING_TITLE3 = "measuring_title_3"
    case MEASURING_TITLE4 = "measuring_title_4"
    case MEASURING_TITLE5 = "measuring_title_5"
    case MEASURING_TITLE6 = "measuring_title_6"
    case MEASURING_TITLE7 = "meas_future_day"
    case MEASURING_TITLE8 = "measuring_title_7"
    case MEASURING_TITLE9 = "measuring_title_9"
    case MEASURING_TITLE10 = "measuring_title_10"
    case MEASURING_TITLE11 = "measuring_title_11"
    case MEASURING_TITLE12 = "measuring_title_12"
    case MEASURING_TITLE13 = "measuring_title_13"
    case MEAS_TITLE_BOTTOM = "meas_title_bottom"
    case HELP_MEAS_FIRST_TITLE = "help_meas_first_title"
    case HELP_MEAS_FIRST_TEXT = "help_meas_first_text"
    case HELP_MEAS_SECOND_TITLE = "help_meas_second_title"
    case HELP_MEAS_SECOND_TEXT = "help_meas_second_text"
    case HELP_MEAS_THIRD_TEXT = "help_meas_third_text"
    
    case PREMIUM_TITLE_2 = "premium_title_2"
    case PREMIUM_TITLE = "premium_title"
    case REACH_GOAL_FASTER = "reach_goal_faster"
    case EVERYDAY_RECIPES = "everyday_recipes"
    case SCIENCE_ARTICLES = "science_articles"
    case TRACE_ELEMENTS_IN_RECIPES = "trace_elements_in_recipes"
    case TRY = "try"
    case COUNT_DAY_TRIAL = "count_day_trial"
    case AMOUNT_PER_MONTH = "amount_per_month"
    case CONNECT_PREMIUM = "connect_premium"
    case TERMS_AND_CONDITIONS = "terms_and_conditions"
    case PAYMENT_DESCRIPTION = "payment_description"
    case SPECIAL_OFFER = "special_offer"
    case PAYMENT_TOP_DESCRIPTION = "payment_top_description"
    case PAYMENT_BOTTOM_DESCRIPTION = "payment_bottom_description"
    case PRIVACY_TITLE = "privacy_title"
    case PAY_DESCRIPTION = "pay_description"
    case PREM_DESCRIPTION_1 = "premium_description_Label"
    case PREM_VERSION_1 = "premium_version"
    
    /*    Premium purchase success Screen    */
    case CONGRATULATIONS = "congratulations"
    case PREMIUM_COURAGE_DESCRIPTION = "premium_courage_description"
    
    /*    Profile Screen    */
    case PROFILE_TITLE = "profile_title"
    case YOUR_NAME = "your_name"
    case DAILY_GOAL = "daily_goal"
    case NUTRITION_PLAN = "nutrition_plan"
    case STANDARD = "standard"
    case WEEK = "week"
    case MONTH = "month"
    case YEAR = "year"
    case REPORTS = "reports"
    case DAILY_RATE = "daily_rate"
    case YOUR_PERFORMANCE = "your_performance"
    case MONDAY = "monday"
    case TUESDAY = "tuesday"
    case WEDNESDAY = "wednesday"
    case THURSDAY = "thursday"
    case FRIDAY = "friday"
    case SATURDAY = "saturday"
    case SUNDAY = "sunday"
    case JANUARY = "january"
    case FEBRUARY = "february"
    case MARCH = "march"
    case APRIL = "april"
    case MAY = "may"
    case JUNE = "june"
    case JULY = "july"
    case AUGUST = "august"
    case SEPTEMBER = "september"
    case OCTOBER = "october"
    case NOVEMBER = "november"
    case DECEMBER = "december"
    case YEAR_SHORT = "year_short"
    
    /*    Setting Screen    */
    case PREMIUM_ACCOUNT = "premium_account"
    case PROMOTIONAL_CODES = "promotional_codes"
    case PERSONAL_DATA = "personal_data"
    case CALORIE_INTAKE = "calorie_intake"
    case EXIT = "exit"
    case LOG_OFF = "log_off"
    case CANCEL = "cancel"
    case APPLY = "apply"
    case DELETE = "remove"
    
    case RECIPE_DETAILS_SUBSC_BTN = "subsc_btn_bay"
    case RECIPE_DETAILS_TITLE_1 = "recipe_details_title_1"
    case RECIPE_DETAILS_TITLE_2 = "recipe_details_title_2"
    
    /*    Promotional Code Screen    */
    case PROMOTIONAL_NAVIGATION = "promotional_navigation"
    case PROMOTIONAL_TITLE = "promotional_title"
    case PROMOTIONAL_DESCRIPTION = "promotional_description"
    case ENTER_PROMOTIONAL_CODE = "enter_promotional_code"
    case ENTER_YOUR_PROMOTIONAL_CODE = "enter_your_promotional_code"
    case ACTIVE_PROMODE = "active_promode"
    case INVALID_PROMOTIONAL_CODE_ERROR = "invalid_promotional_code_error"
    
    /*    Personal Data Screen    */
    case PERSONAL_DATA_NAVIGATION = "personal_data_navigation"
    case DONE = "done"
    case NAME = "name"
    case SURNAME = "surname"
    case EMAIL = "email"
    
    /*    Calorie Intake Screen    */
    case SEX_MALE = "sex_male"
    case SEX_FEMALE = "sex_female"
    case CALORIE_INTAKE_NAVIGATION = "calorie_intake_navigation"
    case GENDER = "gender"
    case GROWTH = "growth"
    case WEIGHT = "weight"
    case AGE = "age"
    case ACTIVITY = "activity"
    case TARGET = "target"
    case SET_YOUR_NORM_TITLE = "set_your_norm_title"
    case SET_YOUR_NORM_DESCRIPTION = "set_your_norm_description"
    //case CALORIE_INTAKE = "calorie_intake"
    case PROTEIN_INTAKE = "protein_intake"
    case CARBOHYDRATES_INTAKE = "carbohydrates_intake"
    case FATS_INTAKE = "fats_intake"
    case DAY_NORM_INTAKE_DESCRIPTION = "day_norm_intake_description"
    case DEFAULT_INTAKE = "default_intake"
    case DEFAULT_DESCRIPTION_INTAKE = "default_description_intake"
    
    /*    Diary Screen    */
    case DIARY_TITLE = "diary_title"
    case DIARY_DAILY_RATE = "diary_daily_rate"
    case EATEN_UP = "eaten_up"
    case BURNT = "burnt"
    case LEFT = "left"
    case EXCESS = "excess"
    case WATER = "water"
    case WATER_UNIT = "water_unit"
    case NORM_ESTABLISHED_FIRST = "norm_established_first"
    case NORM_ESTABLISHED_SECOND = "norm_established_second"
    case BREAKFAST = "breakfast"
    case LUNCH = "lunch"
    case DINNER = "dinner"
    case SNACK = "snack"
    //case ACTIVITY = "activity"
    case ALL = "all"
    case WATER_SETTINGS = "water_settings"
    case LIG_PRODUCT = "lig_product"
    case GRAM_UNIT = "gram_unit"
    case TITLE_CHANGE1 = "title_change_1"
    case DIARY_MES_17 = "diary_mes_17"
    case PRODUCT_CHANGED_IN_BUSKET = "product_changed_in_busket"
    case PRODUCT_ADDED_IN_DIARY = "product_changed_in_diary"
    
    /*    Water Screen    */
    case BENEFIT_WATER_TITLE = "benefit_water_title"
    case BENEFIT_WATER_DESCRIPTION_FIRST = "benefit_water_description_first"
    case BENEFIT_WATER_DESCRIPTION_SECOND = "benefit_water_description_second"
    case BENEFIT_WATER_DESCRIPTION_THIRD = "benefit_water_description_third"
    //case BENEFIT_WATER_TITLE = "benefit_water_title"
    case GENERAL = "general"
    case LITER = "liter"
    case YOUR_DAILY_RATE = "your_daily_rate"
    case MAKE_DEFAULT = "make_default"
    case WATER_ALERT = "water_alert"
    
    /*    Activity Screen    */
    case ALERT_YES = "alert_yes"
    case ALERT_NO = "alert_no"
    case ALERT_CONFIRM2 = "alert_dialog_confirm_question2"
    case ACTIVITY_REMOVE_ALERT = "alert_dialog_confirm_question"
    case ACTIVITY_NAVIGATION = "activity_navigation"
    case MY_ACTIVITY = "my_activity"
    case SEARCH = "search"
    case EMPTY_MY_ACTIVITY_FIRST = "empty_my_activity_first"
    case EMPTY_MY_ACTIVITY_SECOND = "empty_my_activity_second"
    case FAVORITES = "favorites"
    case EMPTY_FAVORITES = "empty_favorites"
    case STANDARD_ACTIVITIES = "standard_activities"
    case ADD_ACTIVITIE = "add_activitie"
    case ADD_NAME_ACTIVITIE = "add_name_activitie"
    case TRAINING_TIME = "training_time"
    case TRAINING_TIME_DESCRIPTION = "training_time_description"
    case MINUTES = "minutes"
    case CALORIES_COUNT = "calories_count"
    case CALORIES_COUNT_DESCRIPTION = "calories_count_description"
    case CALORIES = "calories"
    case ATTENTION = "attention"
    case ADD_PRODUCT_NEW = "add_product_new"
    case ATTENTION_DESCRIPTION = "attention_description"
    case CALORIES_SPENT = "calories_spent"
    case DIARY_MES_13 = "diary_mes_13"
    case DIARY_MES_14 = "diary_mes_14"
    case DIARY_MES_15 = "diary_mes_15"
    case DIARY_MES_16 = "diary_mes_16"
    case FOR = "for"
    case MOVE_SLIDER = "move_slider"
    case ADD_TO_DIARY = "add_to_diary"
    case ALERT_ADD = "alert_add"
    case RESULT_SEARCH = "result_search"
    case SELECTED_BASKET = "selected_basket"
    case COUNT_PRODUCTS = "count_products"
    case ADD_USER_ACTIVITY_HINT = "add_user_activity_hint"
    case MINIMAL_CALORIES_COUNT = "minimal_calories_count"
    
    case COMPLEXITY_TEXT1 = "complexity_text1"
    case COMPLEXITY_TEXT2 = "complexity_text2"
    case COMPLEXITY_TEXT3 = "complexity_text3"
    case COMPLEXITY_TEXT4 = "complexity_text4"
    case COMPLEXITY_TEXT5 = "complexity_text5"
    case COMPLEXITY_TEXT6 = "complexity_text6"
    
    case ALERT_DEVELOPMENT = "alert_development"
    case ALERT_BASKET = "alert_basket"
    
    /*    Search Product Screen    */
    case SEARCH_EMPTY = "search_empty"
    
    /*    Create Product Step Screen    */
    case CREATE_STEP_TITLE_1 = "create_step_title_1"
    case CREATE_STEP_TITLE_2 = "create_step_title_2"
    case CREATE_STEP_TITLE_3 = "create_step_title_3"
    case CREATE_STEP_TITLE_4 = "create_step_title_4"
    case CREATE_STEP_TITLE_5 = "create_step_title_5"
    case CREATE_STEP_TITLE_6 = "create_step_title_6"
    case CREATE_STEP_TITLE_7 = "create_step_title_7"
    case CREATE_STEP_TITLE_8 = "create_step_title_8"
    case CREATE_STEP_TITLE_9 = "create_step_title_9"
    case CREATE_STEP_TITLE_10 = "create_step_title_10"
    case CREATE_STEP_TITLE_11 = "create_step_title_11"
    case CREATE_STEP_TITLE_12 = "create_step_title_12"
    case CREATE_STEP_TITLE_13 = "create_step_title_13"
    case CREATE_STEP_TITLE_14 = "create_step_title_14"
    case CREATE_STEP_TITLE_15 = "create_step_title_15"
    case CREATE_STEP_TITLE_16 = "create_step_title_16"
    case CREATE_STEP_TITLE_17 = "create_step_title_17"
    case CREATE_STEP_TITLE_18 = "create_step_title_18"
    case CREATE_STEP_TITLE_19 = "create_step_title_19"
    case CREATE_STEP_TITLE_20 = "create_step_title_20"
    case CREATE_STEP_TITLE_21 = "create_step_title_21"
    case CREATE_STEP_TITLE_22 = "create_step_title_22"
    case CREATE_STEP_TITLE_23 = "create_step_title_23"
    case CREATE_STEP_TITLE_24 = "create_step_title_24"
    case CREATE_STEP_TITLE_25 = "create_step_title_25"
    case CREATE_STEP_TITLE_26 = "create_step_title_26"
    case CREATE_STEP_TITLE_27 = "create_step_title_27"
    case CREATE_STEP_TITLE_28 = "create_step_title_28"
    case CREATE_STEP_TITLE_29 = "create_step_title_29"
    case CREATE_STEP_TITLE_30 = "create_step_title_30"
    case CREATE_STEP_TITLE_31 = "create_step_title_31"
    case CREATE_STEP_TITLE_32 = "create_step_title_32"
    case CREATE_STEP_TITLE_33 = "create_step_title_33"
    case CREATE_STEP_TITLE_34 = "create_step_title_34"
    case CREATE_STEP_TITLE_35 = "create_step_title_35"
    case CREATE_STEP_TITLE_36 = "create_step_title_36"
    case CREATE_STEP_TITLE_37 = "create_step_title_37"
    case CREATE_STEP_TITLE_38 = "create_step_title_38"
    
    
    
    
    
    
    
    /*    My Product List Screen    */
    case ADD_PRODUCT = "add_product"
    case PRODUCT_NOT_FOUND = "product_not_found"
    case PRODUCT_LIST_EMPTY = "product_list_empty"
    case MY_PRODUCT_TITLE_1 = "my_product_title_1"
    
    /*    My Recipes List Screen    */
    case SEARCH_FIELD_PLACEHOLDER = "search_field_placeholder"
    case ADD_RECIPES = "add_recipes"
    case RECIPES_NOT_FOUND = "recipes_not_found"
    case RECIPES_LIST_EMPTY = "recipes_list_empty"
    case CREATE_PRODUCT = "create_product"
    case CREATE_RECIPES = "create_recipes"
    
    /*    Recipe Creation Screen    */
    case RECIPES_NAME = "recipes_name"
    case RECIPES_IMAGE = "recipes_image"
    case DOWNLOAD = "download"
    case GALLERY = "gallery"
    case PHOTO = "photo"
    case TIME_FOR_PREPARING = "time_for_preparing"
    //case SIGN_IN_TITLE = "photo"
    case MIN = "min"
    case COMPLEXITY = "complexity"
    case CHOOSE_COMPLEXITY = "choose_complexity"
    case EASY = "easy"
    case MEDIUM = "medium"
    case СOMPLEX = "сomplex"
    case ALL_USERS_CAN_SEE = "all_users_can_see"
    case ALL_USERS_CAN_SEE_DESCRIPTION = "all_users_can_see_description"
    case INGREDIENTS_FOR_SERVING = "ingredients_for_serving"
    case INSTRUCTION = "instruction"
    case ADD_INSTRUCTION = "add_instruction"
    case INSTRUCTION_DESCRIPTION = "instruction_description"
    case RECIPES_INFO = "recipes_info"
    case INGREDIENTS = "ingredients"
    case VERIFICATION_OF_INFORMATION = "verification_of_information"
    
    /*    Product Creation Screen    */
    case BRAND_MANUFACTURER = "brand_manufacturer"
    case PRODUCT_NAME = "product_name"
    case BARCODE = "barcode"
    case BARCODE_SCANNING = "barcode_scanning"
    case BARCODE_SCANNING_DESCRIPTION = "barcode_scanning_description"
    case PRODUCT_CALORIES = "product_calories"
    case NUTRIENTS = "nutrients"
    case СELLULOSE = "сellulose"
    case SUGAR = "sugar"
    case SATURATED_FAT = "saturated_fat"
    case MONOUNSATURATED_FAT = "monounsaturated_fat"
    case POLYUNSATURATED_FATS = "polyunsaturated_fats"
    case CHOLESTEROL = "cholesterol"
    case SODIUM = "sodium"
    case POTASSIUM = "potassium"
    case PRODUCT_INFO = "product_info"
    case NUTRITIONAL_VALUE = "nutritional_value"
    case PRODUCT_ADDED_TO_YOUR_PRODUCTS = "product_added_to_your_products"
    case PRODUCT_DETAILS_DESC = "product_details_desc"
    
    /*    Product Details Screen    */
    case PRODUCT_CALCULATION = "product_calculation"
    case PRODUCT_WEIGHS = "product_weighs"
    case PRODUCT_ADD_NUTRIENTS = "product_add_nutrients"
    case REPORT_BUG = "report_bug"
    
    /*    Recipe Details Screen    */
    case PORTION = "portion"
    case SERVINGS = "servings"
    case INGREDIENTS_ON = "ingredients_on"
    case СOOKING_METHOD = "сooking_method"
    case RECIPE_ADDED = "recipe_added"
    
    /*    Calories Intake Screen    */
    case WRITE_GROWTH = "write_growth"
    case WRITE_WEIGHT = "write_weight"
    case WRITE_AGE = "write_age"
    case CHECK_YOUR_AGE = "check_your_age"
    case CHECK_WRITTEN_WEIGHT = "check_written_weight"
    case CHECK_WRITTEN_AGE = "check_written_age"
    case CHECK_WRITTEN_CALORIES = "check_written_calories"
    case CHECK_WRITTEN_PROTEIN_DESCRIPTION = "check_written_protein_description"
    case CHECK_WRITTEN_CARBOHYDRATES_DESCRIPTION = "check_written_carbohydrates_description"
    case CHECK_WRITTEN_FATS_DESCRIPTION = "check_written_fats_description"
    case WRITE_YOUR_NAME = "write_your_name"
    case CHECK_YOUR_NAME = "check_your_name"
    case CHECK_YOUR_LAST_NAME = "check_your_last_name"
    case CHECK_YOUR_EMAIL = "check_your_email"
    
    case ARTICLE_PREMIUM_DESCRIPTION = "article_premium_description"
    case ARTICLE_PREMIUM_BUTTON = "article_premium_button"
    case ADD_PRODUCT_IN_JOURNAL = "add_product_in_journal"
    case REMOVE_PRODUCT = "remove_product"
    
    case ACTIVITY_DESCRIPTION_1 = "activiti_description_1"
    case ACTIVITY_DESCRIPTION_2 = "activiti_description_2"
    
    /*    Default Activity  List  */
    case AIKIDO = "aikido"
    case AQUA_RUN = "aqua_run"
    case WATER_AEROBICS = "water_aerobics"
    case MOUNTAINEERING = "mountaineering"
    case AMERICAN_FOOTBALL = "american_football"
    case ARMY_PRESS = "army_press"
    case AEROBICS_HIGH_LOAD = "aerobics_high_load"
    case AEROBICS_MEDIUM_LOAD = "aerobics_medium_load"
    case BADMINTON_HIGH_LOAD = "badminton_high_load"
    case BADMINTON_MEDIUM_LOAD = "badminton_medium_load"
    case BASKETBALL_HIGH_LOAD = "basketball_high_load"
    case BASKETBALL_MEDIUM_LOAD = "basketball_medium_load"
    case RUN_11_3_KM = "run_11.3_km/h"
    case RUN_12_1_KM = "run_12.1_km/h"
    case RUN_12_9_KM = "run_12.9_km/h"
    case RUN_14_5_KM = "run_14.5_km/h"
    case RUN_16_09_KM = "run_16.09_km/h"
    case RUN_17_7_KM = "run_17.7_km/h"
    case RUN_6_4_KM = "run_6.4_km/h"
    case RUN_8_KM = "run_8_km/h"
    case RUN_9_7_KM = "run_9.7_km/h"
    case RUNNING_UP_THE_STAIRS = "running_up_the_stairs"
    case СROSS_COUNTRY_RUNNING = "сross_country_running"
    case SAND_RUNNING = "sand_running"
    case JOGGING = "jogging"
    case TREADMILL = "treadmill"
    case BASEBALL = "baseball"
    case BIATHLON = "biathlon"
    case BIKRAM_YOGA = "bikram_yoga"
    case BILLIARDS = "billiards"
    case ARM_CURL_BICEPS = "arm_curl(Biceps)"
    case BODY_STEP = "body_step"
    case MARTIAL_ARTS = "martial_arts"
    case BOXING = "boxing"
    case BOXING_HIGH_LOAD = "boxing_high_load"
    case BOXING_TRAINING = "boxing_training"
    case BOXING_PUNCHING_BAG = "boxing_punching_bag"
    case BOWLING = "bowling"
    case QUICK_RUN_UP_STAIRS = "quick_run_up_stairs"
    case BRISK_WALKING_65 = "brisk_walking_6.5_km/h"
    case WAKEBOARDING = "wakeboarding"
    case BICYCLE_AEROBICS_HIGH_LOAD = "bicycle_aerobics_high_load"
    case BICYCLE_AEROBICS_MEDIUM_LOAD = "bicycle_aerobics_medium_load"
    case CYCLING_HIGH_LOAD = "cycling_high_load"
    case CYCLING_MEDIUM_LOAD = "cycling_medium_load"
    case HORSEBACK_RIDING = "horseback_riding"
    case HORSEBACK_RIDING_DRESSAGE = "horseback_riding_dressage"
    case HORSE_RIDING_GALLOP = "horse_riding_gallop"
    case HORSE_RIDING_OBSTACLES = "horse_riding_obstacles"
    case HORSE_RIDING_LYNX = "horse_riding_lynx"
    case WINDSURFING = "windsurfing"
    case WATER_GYMNASTICS = "water_gymnastics"
    case WATER_POLO = "water_polo"
    case VOLLEYBALL_HIGH_LOAD = "volleyball_high_load"
    case VOLLEYBALL_LIGHT_LOAD = "volleyball_light_load"
    case HANDBALL = "handball"
    case GYMNASTICS = "gymnastics"
    case GYMNASTICS_INTENSIVE = "gymnastics_intensive"
    case GYMNASTICS_AVERAGE_LOAD = "gymnastics_average_load"
    case KETTLEBELL_TRAINING = "kettlebell_training"
    case LAUNDRY_IRONING = "laundry_ironing"
    case GOLF_NORMAL = "golf_normal"
    case ALPINE_SKIING_HIGH_LOAD = "alpine_skiing_high_load"
    case ALPINE_SKIING_MEDIUM_LOAD = "alpine_skiing_medium_load"
    case ALPINE_SKIING_MODERATE_LOAD = "alpine_skiing_moderate_load"
    case KAYAKING = "kayaking"
    case CANOEING = "canoeing"
    case ROWING_HIGH_LOAD = "rowing_high_load"
    case ROWING_LOW_LOAD = "rowing_low_load"
    case ROWING_MEDIUM_LOAD = "rowing_medium_load"
    case DIVING = "diving"
    case SCUBA_DIVING = "scuba_diving"
    case JUDO = "judo"
    case BENCH_PRESS = "bench_press"
    case LEG_PRESS = "leg_press"
    case WINTER_KITING = "winter_kiting"
    case ZUMBA = "zumba"
    case DRUMMING = "drumming"
    case INTENSE_WALK = "intense_walk"
    case HIIT_INTERVAL_TRAINING = "hiit_interval_training"
    case YOGA = "yoga"
    case KITESURFING = "kitesurfing"
    case KARATE = "karate"
    case CARDIOVASCULAR_EQUIPMENT = "cardiovascular_equipment"
    case CROSS_COUNTRY_SKIING = "cross_country_skiing"
    case RIDING_BICYCLE = "riding_bicycle"
    case WATER_SKIING = "water_skiing"
    case MOUNTAIN_BIKING = "mountain_biking"
    case SKATING = "skating"
    case ICE_SKATING_HIGH_LOAD = "ice_skating_high_load"
    case CROSS_COUNTRY_SKIING_HIGH_LOAD = "cross_country_skiing_high_load"
    case CROSS_COUNTRY_SKIING_MODERATE_EXERCISE = "cross_country_skiing_moderate_exercise"
    case SKIING_MEDIUM_LOAD = "skiing_medium_load"
    case ROLLER_SKATING = "roller_skating"
    case IN_LINE_SKIING = "in-line_skiing"
    case SCOOTER_RIDING = "scooter_riding"
    case SLEDGING = "sledging"
    case SKATEBOARDING = "skateboarding"
    case SNOWBOARDING = "snowboarding"
    case PRESS_SWING = "press_swing"
    case CURLING = "curling"
    case KICKBOXING = "kickboxing"
    case DIGGING_THE_EARTH = "digging_the_earth"
    case MOWING_GRASS = "mowing_grass"
    case CROSS_SKATING = "cross_skating"
    case СROSS_TRAINER = "сross_trainer"
    case СROSSFIT = "сrossfit"
    case СIRCULAR_TRAINING = "сircular_training"
    case HOOP_TORSION = "hoop_torsion"
    case BODYBUILDING = "bodybuilding"
    case LACROSSE = "lacrosse"
    //case PORTION = "portion"
    case SLOW_WALKING_45 = "slow_walking_4.5_km/h"
    case WINDOW_CLEANING = "window_cleaning"
    case MOTOCROSS = "motocross"
    case CAR_WASH = "car_wash"
    case SLOPES = "slopes"
    case TABLE_TENNIS = "table_tennis"
    case PUSH_UPS = "push_ups"
    case POWERLIFTING = "powerlifting"
    case HIKING = "hiking"
    case HIKING_WITH_BACKPACK = "hiking_with_backpack."
    case PILATES = "pilates"
    case BUTTERFLY_SWIMMING = "butterfly_swimming"
    case BREASTSTROKE = "breaststroke"
    case BACKSTROKE = "backstroke"
    case SAILING = "sailing"
    case SNORKELING = "snorkeling"
    case SWIMMING_HIGH_LOAD = "swimming_high_load"
    case SWIMMING_LOW_LOAD = "swimming_low_load"
    case SWIMMING_FREE = "swimming_free"
    case SWIMMING_MEDIUM_LOAD = "swimming_medium_load"
    case LYING_HIPS = "lying_hips"
    case PULL_UPS = "pull-ups"
    case CLIMBING_STAIRS = "climbing_stairs"
    case POLO = "polo"
    case OBSTACLE_COURSE = "obstacle_course"
    case SQUAT_ON_ONE_LEG = "squat_on_one_leg"
    case SHOULDER_SQUAT = "shoulder_squat"
    case STROLL = "stroll"
    case WALKING_IN_NO_HURRY = "walking_in_no_hurry"
    case WALK_THROUGH_THE_WOODS = "walk_through_the_woods"
    case PROFESSIONAL_FOOTBALL = "professional_football"
    case LONG_JUMP = "long_jump"
    case TRAMPOLINE_AMATEUR = "trampoline_amateur"
    case ROPE_JUMPING = "rope_jumping"
    case VACUUMING = "vacuuming"
    case WORK_WITH_A_RAKE = "work_with_a_rake"
    case STRETCHING = "stretching"
    case RUGBY = "rugby"
    case GARDENING = "gardening"
    case SALSA = "salsa"
    case SEX = "sex"
    case SURFING = "surfing"
    case POWER_YOGA = "power_yoga"
    case POWER_TRAINING = "power_training"
    case STRENGTH_EXERCISES = "strength_exercises"
    case SYNCHRONIZED_SWIMMING = "synchronized_swimming"
    case ROCK_CLIMBING = "rock_climbing"
    case NORDIC_WALKING = "nordic_walking"
    case TWISTING = "twisting"
    case MIXED_MARTIAL_ARTS = "mixed_martial_arts"
    case ORIENTEERING = "orienteering"
    case DEADLIFT = "deadlift"
    case STEP = "step"
    case STEP_PLATFORM = "step_platform"
    case PAN = "pan"
    case THAI_BOXING = "thai_boxing"
    case DANCE_AEROBICS = "dance_aerobics"
    case DANCING = "dancing"
    case POLE_DANCING = "pole_dancing"
    case TWIST = "twist"
    case TENNIS = "tennis"
    case CLEANING = "cleaning"
    case SNOW_REMOVAL_WITH_SHOVEL = "snow_removal_with_shovel"
    case BURPEE_EXERCISE = "burpee_exercise"
    case EXERCISE_PLANK = "exercise_plank"
    case EXERCISE_LUNGES = "exercise_lunges"
    case FENCING = "fencing"
    case FRISBEE = "frisbee"
    case FOOTBALL = "football"
    case WALKING_UP_THE_STAIRS = "walking_up_the_stairs"
    case INDOOR_WALKING = "indoor_walking"
    case WALKING_5_KM = "walking_5_km/h"
    case HOCKEY = "hockey"
    case STICK_WALKING = "stick_walking"
    //case GYMNASTICS = "gymnastics"
    case SHOPPING = "shopping"
    case ELLIPTICAL_TRAINER_HIGH_LOAD = "elliptical_trainer_high_load"
    case ELLIPTICAL_TRAINER_MEDIUM_LOAD = "elliptical_trainer_medium_load"
    case ELLIPTICAL_TRAINER_LOW_LOAD = "elliptical_trainer_low_load"
    
}

public func LS(key: LS_STRING) -> String {
    return key.rawValue.Localized()
}

public func LS_WEEK(index: Int) -> String {
    switch index {
    case 0:
        return LS(key: .MONDAY)
    case 1:
        return LS(key: .TUESDAY)
    case 2:
        return LS(key: .WEDNESDAY)
    case 3:
        return LS(key: .THURSDAY)
    case 4:
        return LS(key: .FRIDAY)
    case 5:
        return LS(key: .SATURDAY)
    case 6:
        return LS(key: .SUNDAY)
    default:
        return ""
    }
}

public extension String {
    
    func Localized() -> String {
        return localizedString(using: nil, in: .main)
    }
}

public extension String {
    
    func localizedString(using tableName: String?, in bundle: Bundle?) -> String {
        let bundle: Bundle = bundle ?? .main
        if let appLanguage = StorageService.get(by: .APP_LANGUAGE) as? String,
            let path = bundle.path(forResource: appLanguage, ofType: "lproj"),
            let bundle = Bundle(path: path) {
            return bundle.localizedString(forKey: self, value: nil, table: tableName)
        } else if let path = bundle.path(forResource: "Base", ofType: "lproj"),
            let bundle = Bundle(path: path) {
            return bundle.localizedString(forKey: self, value: nil, table: tableName)
        }
        return self
    }
}
