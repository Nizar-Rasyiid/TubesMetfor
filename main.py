import pygame
import sys

# Inisialisasi pygame
pygame.init()

# Lebar dan tinggi jendela
width, height = 800, 600

# Warna
white = (255, 255, 255)

# Buat jendela
screen = pygame.display.set_mode((width, height))
pygame.display.set_caption("Kelompok Metode Formal")

# Koordinat awal pesan
x, y = 50, height // 2

# Kecepatan gerakan pesan
speed = 10

# Font teks
font = pygame.font.Font(None, 36)

# Pesan perkenalan
messages = ["Kelompok Metfor", "Nizar", "Hasan", "Naswan", "Theo"]

# Indeks pesan yang sedang ditampilkan
message_index = 0

# Loop utama
running = True
while running:
    for event in pygame.event.get():
        if event.type == pygame.QUIT:
            running = False

    # Bersihkan layar dengan warna putih
    screen.fill(white)

    # Membuat objek teks dan menampilkannya
    text = font.render(messages[message_index], True, (0, 0, 0))
    screen.blit(text, (y, x))

    # Menggerakkan pesan ke kanan
    x += speed

    # Jika pesan melewati batas kanan jendela, lanjutkan dengan pesan berikutnya
    if x > width:
        x = 0
        message_index = (message_index + 1) % len(messages)

    # Tampilkan perubahan di layar
    pygame.display.update()

    # Kontrol kecepatan animasi
    pygame.time.delay(50)

# Keluar dari pygame
pygame.quit()

# Keluar dari Python
sys.exit()
