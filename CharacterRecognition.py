from sklearn.neighbors import NearestNeighbors
import argparse
import sklearn
from sklearn import svm
from sklearn import tree
import numpy
from sklearn.neighbors import NearestNeighbors, KNeighborsClassifier
from sklearn.metrics import confusion_matrix, accuracy_score
from scipy import spatial
from sys import argv
from collections import Counter

class CharacterRecognition:
    def __init__(self, training, test):
        self.training = training[: -4]
        self.test = test[: -4]

    def parseFile(self, training, test):
        with open(training, 'r') as trainingFile, open(test, 'r') as testFile:
            trainingLabels = []
            trainingChars = []
            trainingData = numpy.loadtxt(trainingFile)

            for line in trainingData:
                trainingLabels.append(line[len(trainingData[0]) - 1])
            #for line in trainingData:
                trainingChars.append(line[: - 1])

            numpy.savetxt(self.training + '_label.txt', trainingLabels)
            numpy.savetxt(self.training + '_chars.txt', trainingChars)

            testLabels = []
            testChars = []
            testData = numpy.loadtxt(testFile)

            for line in testData:
                testLabels.append(line[len(testData[0]) - 1])
            #for line in trainingData:
                testChars.append(line[:  - 1])

            numpy.savetxt(self.test + '_label.txt', testLabels)
            numpy.savetxt(self.test + '_chars.txt', testChars)

    def fileToMatrix(self, file):
        with open(file) as file:
            data = numpy.loadtxt(file)
        return data

    def svm(self, training_labels, training_chars, test_chars):
        classifier = svm.SVC(kernel='poly', C=0.5)
        classifier.fit(training_chars, training_labels)
        return classifier.predict(test_chars)

    def decisionTree(self, training_labels, training_chars, test_chars):
        classifier = tree.DecisionTreeClassifier()
        classifier.fit(training_chars, training_labels)
        return classifier.predict(test_chars)

    def knn(self, training_labels, training_chars, test_chars):
        classifier = KNeighborsClassifier(n_neighbors=args.k)
        classifier.fit(training_chars, training_labels)
        return classifier.predict(test_chars)

    def confusionMatrix(self, data, labels):
        return confusion_matrix(labels, data)

    def vote(self, knn, svm, tree):
        result = []
        for i in zip(knn, svm, tree):
            result.append(Counter(i).most_common(1)[0][0])
        return result

    def countClasses(self, matrix):
        classesNumber = 0
        for i in range(25):
            for j in range(25):
                print('[', end='')
                print(matrix[i][j], end='')
                print(']', end='')
            print('\t\t Class = ' + repr(classesNumber) + ' ')
            classesNumber += 1

if __name__ == '__main__':
    args = argparse.ArgumentParser()
    args.add_argument("trainingFile", help="Training file")
    args.add_argument("testFile", help="Test file")
    args.add_argument("k", type=int, help="k neighborhoods")
    args = args.parse_args()

    charsRec = CharacterRecognition(args.trainingFile, args.testFile)
    charsRec.parseFile(args.trainingFile, args.testFile)

    trainingLabelsFile = args.trainingFile[: - 4] + '_label.txt'
    trainingLabels = charsRec.fileToMatrix(trainingLabelsFile)
    trainingCharsFile = args.trainingFile[: - 4] + '_chars.txt'
    trainingChars = charsRec.fileToMatrix(trainingCharsFile)

    testLabelsFile = args.trainingFile[: - 4] + '_label.txt'
    testLabels = charsRec.fileToMatrix(testLabelsFile)
    testCharsFile = args.trainingFile[: - 4] + '_chars.txt'
    testChars = charsRec.fileToMatrix(testCharsFile)

    svm = charsRec.svm(trainingLabels, trainingChars, testChars)
    knn = charsRec.knn(trainingLabels, trainingChars, testChars)
    decisionTree = charsRec.decisionTree(trainingLabels, trainingChars, testChars)

    #vote = charsRec.vote(knn, svm, decisionTree)
    #matrix = charsRec.confusionMatrix(vote, testLabels)
    matrix = charsRec.confusionMatrix(svm, testLabels)

    charsRec.countClasses(matrix)

    accuracy = accuracy_score(testLabels, svm) * 100
    print('Accuracy = ' + repr(accuracy) + '%\n')
    #accuracy = accuracy_score(testLabels, knn) * 100
    #print('Accuracy = ' + repr(accuracy) + '%\n')



