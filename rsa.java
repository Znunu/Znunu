package bin;

import java.io.*;
import java.math.BigInteger;
import java.util.Random;
import java.util.Scanner;

public class RSA {

    //Public
    public final BigInteger n; //mod
    public final BigInteger e; //Exp 1

    //Private
    public final BigInteger d; //Exp 2

    //Random number?!
    public final BigInteger RANDOM_DECIMAL = new BigInteger(????????????????);
    public static final int TEXT_BASE = 256;

    public RSA() {
      this(1000);
    }

    public RSA(int bitLength) {

        int firstLength = bitLength/2;
        int secondLength = firstLength + firstLength/20;
        BigInteger p = BigInteger.probablePrime(firstLength, new Random());
        BigInteger q = BigInteger.probablePrime(secondLength, new Random());
        if (firstLength > RANDOM_DECIMAL.bitLength()) {
            p = p.add(RANDOM_DECIMAL);
            q = q.add(RANDOM_DECIMAL);
            p = p.nextProbablePrime();
            q = q.nextProbablePrime();
        }
        n = p.multiply(q);
        BigInteger pm = p.subtract(BigInteger.ONE);
        BigInteger qm = q.subtract(BigInteger.ONE);
        BigInteger c = pm.multiply(qm).divide(pm.gcd(qm));
        BigInteger te = BigInteger.probablePrime(c.bitLength() - 1, new Random());
        while (te.gcd(c).compareTo(BigInteger.ONE) != 0) {
            te = BigInteger.probablePrime(c.bitLength() - 1, new Random());
        }
        e = te;
        d = e.modInverse(c);
    }

    public RSA(BigInteger n, BigInteger e, BigInteger d) {
        this.n = n;
        this.e = e;
        this.d = d;
    }

    public RSA(BigInteger n, BigInteger e) {
        this.n = n;
        this.e = e;
        this.d = null;
    }

    public RSA(File keyFile) throws Exception {

        FileReader in = new FileReader(keyFile);

        String keyBuffer = "0000";
        String valueBuffer = "";
        int c;
        int keyCount;
        BigInteger[] keys = new BigInteger[3];


        while ((c = in.read()) != -1) {

            if (keyBuffer.equals("K-n:")) {
                keyCount = 0;
            } else if (keyBuffer.equals("K-e:")) {
                keyCount = 1;
            } else if (keyBuffer.equals("K-d:")) {
                keyCount = 2;
            } else {
                keyCount = -1;
            }

            if (keyCount == -1) {
                keyBuffer = keyBuffer.substring(1) + (char) c;
            } else {
                if ((48 <= c) && (c <= 57)) {
                    valueBuffer = valueBuffer + (char) c;
                } else {
                    keys[keyCount] = new BigInteger(valueBuffer);
                    valueBuffer = "";
                    keyBuffer = keyBuffer.substring(1) + "<";
                }
            }
        }
        n = keys[0];
        e = keys[1];
        d = keys[2];

        in.close();

    }

    public int bitLength() {
        return n.bitLength();
    }

    public boolean hasPrivateKey() {
        return (d != null);
    }

    public Message encrypt(Message message) {
        return new Message(message.decimal.modPow(e, n));
    }

    public Message decrypt(Message cipher) {
        return new Message(cipher.decimal.modPow(d, n));
    }

    public Message decrypt(Message cipher, BigInteger index) {
        return new Message(cipher.decimal.modPow(d, n).add(n.multiply(index)));
    }

    public Message sign(Message message) {
        return new Message(String.format(message.text + "%nSIG:" + encrypt(message).decimal));
    }

    public Message unSign(Message message) {
        char[] chars = message.text.toCharArray();
        String buffer = "0000";
        String stringBuild = "";
        for (char codePoint : chars ) {
            if (buffer.equals("SIG:")) {
                if ((48 <= codePoint) && (codePoint <= 57)) {
                    stringBuild = stringBuild + codePoint;
                } else {
                    buffer = buffer.substring(1) + codePoint;
                }
            } else {
                buffer = buffer.substring(1) + codePoint;
            }
        }
        return new Message(message.text.replace(stringBuild, decrypt(new Message(new BigInteger(stringBuild))).text));
    }

    public static int bitToWordLength(int bitLength) {
        return bitLength/(int) (Math.log10(TEXT_BASE)/Math.log10(2));
    }

    public static int wordToBitLength(int wordLength) {
        return wordLength * (int) (Math.log10(TEXT_BASE)/Math.log10(2));
    }

    public void save(File file) throws IOException {

        PrintWriter out = new PrintWriter(new FileWriter(file));
        Scanner in = new Scanner(toString());
        while (in.hasNext()) {
            out.println(in.nextLine());
        }
        out.close();
    }

    @Override
    public String toString() {
        if (hasPrivateKey()) {
            return String.format("Public keys:%nK-n:" + n.toString() + "%nK-e:" + e.toString() + "%n%nPrivate key:%nK-d:" + d.toString() + "%n");
        } else {
            return String.format("Public keys:%K-n:" + n.toString() + "%nK-e:" + e.toString());
        }

    }
}
