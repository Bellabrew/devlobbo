try:
    from PIL import Image, ImageDraw, ImageFont
    import base64, io
    for sz in [192,512]:
        img=Image.new('RGBA',(sz,sz),(27,122,62,255))
        d=ImageDraw.Draw(img)
        m=sz//6; r=sz-m*2
        d.ellipse([m,m,m+r,m+r],fill=(255,255,255,30))
        cx,cy=sz//2,sz//2
        # P
        pw=sz//5; ph=sz//3; px=cx-pw; py=cy-ph//2
        d.rectangle([px,py,px+sz//20,py+ph],fill='white')
        d.ellipse([px,py,px+pw,py+ph//2],fill='white')
        d.ellipse([px+sz//30,py+sz//40,px+pw-sz//40,py+ph//2-sz//40],fill=(27,122,62,255))
        img.save(f'/home/claude/ponto-justificado/icon-{sz}.png')
    print("Ícones criados")
except:
    # Fallback: criar ícone simples com bytes PNG mínimos
    import struct, zlib
    def make_png(size, r, g, b):
        def chunk(name, data):
            c = zlib.crc32(name+data)&0xffffffff
            return struct.pack('>I',len(data))+name+data+struct.pack('>I',c)
        raw = b''
        for _ in range(size):
            row = b'\x00' + bytes([r,g,b]*size)
            raw += row
        compressed = zlib.compress(raw)
        return b'\x89PNG\r\n\x1a\n' + chunk(b'IHDR', struct.pack('>IIBBBBB',size,size,8,2,0,0,0)) + chunk(b'IDAT',compressed) + chunk(b'IEND',b'')
    for sz in [192,512]:
        with open(f'/home/claude/ponto-justificado/icon-{sz}.png','wb') as f:
            f.write(make_png(sz,27,122,62))
    print("Ícones fallback criados")
