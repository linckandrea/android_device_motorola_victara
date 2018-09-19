$(call inherit-product, device/motorola/victara/full_victara.mk)

# Inherit some common cos stuff.
$(call inherit-product, vendor/cos/config/common.mk)

# Overlay
DEVICE_PACKAGE_OVERLAYS += $(LOCAL_PATH)/overlay

PRODUCT_RELEASE_NAME := MOTO X (2014)
PRODUCT_NAME := cos_victara

PRODUCT_GMS_CLIENTID_BASE := android-motorola
